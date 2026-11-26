<div class="mt-6 flex w-full flex-col gap-6{if !$dating_profile} mx-auto max-w-3xl{/if}">

  {if $dating_locked}
    <div class="alert alert-soft alert-warning flex flex-wrap items-center gap-3" role="status">
      <span class="icon-[tabler--rosette-discount-check] size-5 shrink-0" aria-hidden="true"></span>
      <span class="min-w-0 grow">{__("Only verified members can use dating")}</span>
      {if $system['verification_requests']}
        <a class="heroui button button--primary [--button-bg:var(--warning)] [--button-bg-hover:var(--warning-hover)] [--button-bg-pressed:var(--warning-hover)] [--button-fg:var(--warning-foreground)] button--sm" href="{$system['system_url']}/settings/verification">{__("Get Verified")}</a>
      {/if}
    </div>
  {/if}

  {if !$dating_profile}
    <!-- welcome -->
    <section class="relative overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] border border-primary/20 bg-base-100">
      <span class="pointer-events-none absolute inset-0 bg-linear-to-br from-primary/15 via-primary/5 to-transparent" aria-hidden="true"></span>
      <div class="relative flex flex-wrap items-center gap-4 p-6 sm:p-8">
        <span class="inline-flex size-12 shrink-0 items-center justify-center rounded-2xl bg-primary text-primary-content" aria-hidden="true">
          <span class="icon-[tabler--heart-filled] size-6"></span>
        </span>
        <div class="min-w-0 grow basis-52">
          <h2 class="text-xl font-bold tracking-tight">{__("Create your dating profile")}</h2>
          <p class="text-sm text-base-content/60">{__("Your dating profile is separate from your main profile and only visible to other dating members")}</p>
        </div>
      </div>
    </section>
    <!-- welcome -->
  {elseif $dating_profile['status'] == "suspended"}
    <div class="alert alert-soft alert-error items-center" role="alert">
      <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
      {__("Your dating profile has been suspended")}
    </div>
  {elseif $dating_profile['status'] == "paused"}
    <div class="alert alert-soft alert-warning flex flex-wrap items-center gap-3" role="status">
      <span class="icon-[tabler--player-pause] size-5 shrink-0" aria-hidden="true"></span>
      <span class="min-w-0 grow">{__("Your dating profile is paused and hidden from everyone")}</span>
      <button type="button" class="heroui button button--primary [--button-bg:var(--warning)] [--button-bg-hover:var(--warning-hover)] [--button-bg-pressed:var(--warning-hover)] [--button-fg:var(--warning-foreground)] button--sm js_dating-status" data-status="active">{__("Resume")}</button>
    </div>
  {elseif !$dating_photos}
    <div class="alert alert-soft alert-info items-center" role="status">
      <span class="icon-[tabler--photo-plus] size-5 shrink-0" aria-hidden="true"></span>
      {__("Add at least one photo to start meeting people")}
    </div>
  {/if}

  <div class="grid gap-6{if $dating_profile} lg:grid-cols-[minmax(0,1fr)_22rem] lg:items-start{/if}">
    <div class="relative isolate flex min-w-0 flex-col gap-8 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-100 p-5 sm:p-6 xl:p-8">
      {if $dating_photos}
        <!-- backdrop -->
        <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-100" aria-hidden="true">
          <img class="absolute inset-0 size-full scale-110 object-cover opacity-40 blur-2xl" src="{$dating_photos[0]['url']}" alt="">
          <span class="absolute inset-0 bg-linear-to-t from-base-100 via-base-100/85 to-base-100/40"></span>
        </div>
        <!-- backdrop -->
      {/if}

      {if $dating_profile && $dating_profile['status'] != "suspended"}
        <!-- photos -->
        <section>
          <h2 class="flex items-center gap-2 text-lg font-semibold">
            <span class="icon-[tabler--photo] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Photos")}
          </h2>
          <p class="mt-0.5 text-sm text-base-content/60">{__("Drag to reorder, your first photo is your main one")}</p>
          <div class="mt-4">
            <ul class="js_dating-photos grid grid-cols-3 gap-3 sm:grid-cols-4 xl:grid-cols-5">
              {include file='__dating_photos.tpl'}
            </ul>
            <div class="mt-4 flex flex-wrap items-center gap-4">
              {include file='__x_image.tpl' _x_handle="dating" _x_name="dating_photo" _x_class="size-24 rounded-2xl! border-base-content/20! bg-base-100/70! backdrop-blur-md js_dating-photo-uploader" _x_label=__("Add Photo")}
              <p class="min-w-0 grow basis-52 text-sm text-base-content/60">
                {__("You can add up to")} {$system['dating_max_photos']} {__("photos")}{if $system['dating_photos_approval']}. {__("New photos are reviewed before they appear")}{/if}
              </p>
            </div>
          </div>
        </section>
        <!-- photos -->
      {/if}

      {if !$dating_profile || $dating_profile['status'] != "suspended"}
        <!-- profile -->
        <section>
          <form class="js_ajax-forms" data-url="dating/profile.php?do=save">
            <h2 class="flex items-center gap-2 text-lg font-semibold">
              <span class="icon-[tabler--user-heart] size-5 text-base-content/60" aria-hidden="true"></span>
              {__("Dating Profile")}
            </h2>
            <p class="mt-0.5 text-sm text-base-content/60">{__("What other members see about you")}</p>
            <div class="mt-5 flex flex-col gap-8">
              <!-- about -->
              <section class="grid gap-4 sm:grid-cols-2">
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="dating-birthdate">{__("Birthdate")}</label>
                  {if $dating_profile}
                    <input id="dating-birthdate" type="date" class="input w-full" value="{$dating_profile['birthdate']}" disabled>
                  {else}
                    <input id="dating-birthdate" type="date" class="input w-full" name="birthdate" value="{$user->_data['user_birthdate']}" required>
                  {/if}
                </div>
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="dating-profile-gender">{__("I am")}</label>
                  <select id="dating-profile-gender" class="select w-full" name="gender">
                    {foreach $genders as $_gender}
                      <option {if ($dating_profile && $dating_profile['gender'] == $_gender['gender_id']) || (!$dating_profile && $user->_data['user_gender'] == $_gender['gender_id'])}selected{/if} value="{$_gender['gender_id']}">{$_gender['gender_name']}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="min-w-0 sm:col-span-2">
                  <label class="label-text mb-1.5 block" for="dating-bio">{__("About Me")}</label>
                  <textarea id="dating-bio" class="textarea w-full" name="bio" rows="3" maxlength="500" dir="auto">{$dating_profile['bio']}</textarea>
                </div>
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="dating-country">{__("Country")}</label>
                  <select id="dating-country" class="select w-full" name="country">
                    <option value="0">{__("Select Country")}</option>
                    {foreach $countries as $_country}
                      <option {if ($dating_profile && $dating_profile['country_id'] == $_country['country_id']) || (!$dating_profile && $user->_data['user_country'] == $_country['country_id'])}selected{/if} value="{$_country['country_id']}">{$_country['country_name_with_flag']}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="dating-profile-city">{__("City")}</label>
                  <input id="dating-profile-city" type="text" class="input w-full" name="city" maxlength="100" value="{if $dating_profile}{$dating_profile['city']}{else}{$user->_data['user_current_city']}{/if}">
                </div>
              </section>
              <!-- about -->

              <!-- interests -->
              {if $dating_interests}
                <section class="flex flex-col gap-3">
                  <h3 class="flex items-center gap-2 text-lg font-semibold">
                    <span class="icon-[tabler--sparkles] size-5 text-base-content/60" aria-hidden="true"></span>
                    {__("Interests")}
                  </h3>
                  <p class="-mt-1 text-xs text-base-content/60">{__("You can select up to")} {$system['dating_max_interests']} {__("interests")}</p>
                  <div class="flex flex-wrap gap-2">
                    {foreach $dating_interests as $_interest}
                      <label class="inline-flex cursor-pointer items-center gap-1.5 rounded-full bg-base-content/10 px-4 py-2 text-sm font-medium backdrop-blur-md transition-colors hover:bg-base-content/15 has-[:checked]:bg-primary/20">
                        <input type="checkbox" class="peer sr-only" name="interests[]" value="{$_interest['interest_id']}" {if in_array($_interest['interest_id'], $profile_interests)}checked{/if}>
                        <span aria-hidden="true">{$_interest['icon']}</span>
                        {__($_interest['title'])}
                        <span class="icon-[tabler--circle-check-filled] hidden size-4 text-primary peer-checked:inline-block" aria-hidden="true"></span>
                      </label>
                    {/foreach}
                  </div>
                </section>
              {/if}
              <!-- interests -->

              <!-- preferences -->
              <section class="flex flex-col gap-4">
                <h3 class="flex items-center gap-2 text-lg font-semibold">
                  <span class="icon-[tabler--adjustments-horizontal] size-5 text-base-content/60" aria-hidden="true"></span>
                  {__("Who I Want to Meet")}
                </h3>
                <div class="{if $system['genders_disabled']}hidden{/if}">
                  <div class="label-text mb-1.5">{__("Looking For")}</div>
                  <div class="flex flex-wrap gap-2">
                    {foreach $genders as $_gender}
                      <label class="inline-flex cursor-pointer items-center gap-1.5 rounded-full bg-base-content/10 px-4 py-2 text-sm font-medium backdrop-blur-md transition-colors hover:bg-base-content/15 has-[:checked]:bg-primary/20">
                        <input type="checkbox" class="peer sr-only" name="show_genders[]" value="{$_gender['gender_id']}" {if $dating_profile && in_array($_gender['gender_id'], $dating_profile['show_genders'])}checked{/if}>
                        {$_gender['gender_name']}
                        <span class="icon-[tabler--circle-check-filled] hidden size-4 text-primary peer-checked:inline-block" aria-hidden="true"></span>
                      </label>
                    {/foreach}
                  </div>
                  <p class="mt-1.5 text-xs text-base-content/60">{__("Leave empty to see everyone")}</p>
                </div>
                <div class="grid gap-4 sm:grid-cols-3">
                  <div class="min-w-0">
                    <label class="label-text mb-1.5 block" for="dating-profile-min-age">{__("Min Age")}</label>
                    <input id="dating-profile-min-age" type="number" class="input w-full" name="min_age" min="{$system['dating_min_age']}" max="99" value="{if $dating_profile}{$dating_profile['min_age']}{else}{$system['dating_min_age']}{/if}">
                  </div>
                  <div class="min-w-0">
                    <label class="label-text mb-1.5 block" for="dating-profile-max-age">{__("Max Age")}</label>
                    <input id="dating-profile-max-age" type="number" class="input w-full" name="max_age" min="{$system['dating_min_age']}" max="99" value="{if $dating_profile}{$dating_profile['max_age']}{else}99{/if}">
                  </div>
                  <div class="min-w-0">
                    <label class="label-text mb-1.5 block" for="dating-profile-distance">{__("Max Distance")}</label>
                    <label class="input w-full">
                      <input id="dating-profile-distance" type="number" class="grow" name="max_distance" min="1" max="{$system['dating_max_distance']}" value="{if $dating_profile}{$dating_profile['max_distance']}{else}{$system['dating_max_distance']}{/if}">
                      <span class="my-auto ms-2 shrink-0 text-sm text-base-content/60">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
                    </label>
                  </div>
                </div>
                {if !$dating_profile || $dating_profile['latitude'] === null}
                  <p class="text-xs text-base-content/60">{__("Distance is used when you share your location, otherwise you see members from your city and country")}</p>
                {/if}
              </section>
              <!-- preferences -->

              <!-- privacy -->
              <section class="flex flex-col gap-4">
                <h3 class="flex items-center gap-2 text-lg font-semibold">
                  <span class="icon-[tabler--lock] size-5 text-base-content/60" aria-hidden="true"></span>
                  {__("Privacy")}
                </h3>
                <div class="flex flex-col divide-y divide-base-content/5 overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-100/70 ring-1 ring-inset ring-base-content/5 backdrop-blur-md">
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--users-minus] size-5"></span>
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="hide_from_friends-label">{if $system['friends_enabled']}{__("Hide me from my friends")}{else}{__("Hide me from people I follow")}{/if}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("They will not see you in dating and you will not see them")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="hide_from_friends-label" type="checkbox" name="hide_from_friends" {if !$dating_profile || $dating_profile['hide_from_friends']}checked{/if}>
                  </div>
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--cake-off] size-5"></span>
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="hide_age-label">{__("Hide my age")}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Other members will not see your age")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="hide_age-label" type="checkbox" name="hide_age" {if $dating_profile['hide_age']}checked{/if}>
                  </div>
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--map-pin-off] size-5"></span>
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="hide_distance-label">{__("Hide my distance")}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Your exact location is never shown")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="hide_distance-label" type="checkbox" name="hide_distance" {if $dating_profile['hide_distance']}checked{/if}>
                  </div>
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--spy] size-5"></span>
                    </span>
                    <div class="min-w-0 grow">
                      <div class="flex flex-wrap items-center gap-2 text-sm font-medium" id="incognito-label">
                        {__("Incognito mode")}
                        {if !$can_use_incognito}
                          <a class="badge badge-soft badge-primary badge-sm rounded-full" href="{$system['system_url']}/packages">{__("Upgrade")}</a>
                        {/if}
                      </div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Only the members you liked can see you")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px] [--color-neutral:var(--color-base-content)] disabled:before:bg-current" aria-labelledby="incognito-label" type="checkbox" name="incognito" {if $dating_profile['incognito'] && $can_use_incognito}checked{/if} {if !$can_use_incognito}disabled{/if}>
                  </div>
                </div>
              </section>
              <!-- privacy -->

              <!-- success -->
              <div class="alert alert-success hidden items-center" role="status"></div>
              <!-- success -->

              <!-- error -->
              <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
              <!-- error -->
            </div>
            <div class="mt-8 flex justify-end gap-3">
              <button type="submit" class="heroui button button--primary w-full px-6 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{if $dating_profile}{__("Save Changes")}{else}{__("Join Dating")}{/if}</button>
            </div>
          </form>
        </section>
        <!-- profile -->
      {/if}
    </div>

    {if $dating_profile}
      <aside class="flex min-w-0 flex-col gap-6 lg:sticky lg:top-24">
        {if $dating_ready}
          {include file='__dating_plan.tpl'}
        {/if}

        <!-- account -->
        <section class="flex flex-col gap-4">
          {if $dating_profile['status'] == "active"}
          <div class="relative flex items-center gap-3 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5 text-base-content dark:bg-slate-950 dark:text-white">
            <span class="pointer-events-none absolute -end-10 -top-10 size-32 rounded-full bg-amber-500/20 dark:bg-amber-500/25 blur-2xl" aria-hidden="true"></span>
            <span class="relative inline-flex size-11 shrink-0 items-center justify-center rounded-full border border-amber-500/20 bg-amber-500/10 dark:border-white/10 dark:bg-white/5" aria-hidden="true">
              <span class="icon-[tabler--player-pause-filled] size-5 text-amber-500 dark:text-amber-400"></span>
            </span>
            <div class="relative min-w-0 grow">
              <div class="font-semibold">{__("Pause my profile")}</div>
              <p class="mt-0.5 text-xs text-base-content/60 dark:text-white/60">{__("Hide your profile from everyone, your matches stay")}</p>
            </div>
            <button type="button" class="heroui button button--tertiary button--sm relative shrink-0 px-3.5 text-xs rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] dark:border-white/10 dark:bg-white/10 dark:text-white js_dating-status" data-status="paused">{__("Pause")}</button>
          </div>
          {/if}
          <div class="relative flex items-center gap-3 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5 text-base-content dark:bg-slate-950 dark:text-white">
            <span class="pointer-events-none absolute -end-10 -top-10 size-32 rounded-full bg-red-500/20 dark:bg-red-500/25 blur-2xl" aria-hidden="true"></span>
            <span class="relative inline-flex size-11 shrink-0 items-center justify-center rounded-full border border-red-500/20 bg-red-500/10 dark:border-white/10 dark:bg-white/5" aria-hidden="true">
              <span class="icon-[tabler--door-exit] size-5 text-red-500 dark:text-red-400"></span>
            </span>
            <div class="relative min-w-0 grow">
              <div class="font-semibold">{__("Leave dating")}</div>
              <p class="mt-0.5 text-xs text-base-content/60 dark:text-white/60">{__("Delete your dating profile, photos, likes and matches")}</p>
            </div>
            <button type="button" class="heroui button button--danger-soft button--sm relative shrink-0 px-3.5 text-xs rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_dating-leave">{__("Delete")}</button>
          </div>
        </section>
        <!-- account -->
      </aside>
    {/if}
  </div>

</div>
