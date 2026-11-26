{if $sub_view == ""}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=basic">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--user]" _title=__("Basic") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        {if !$system['show_usernames_enabled'] && $user->_data['user_verified']}
          <div class="alert alert-warning flex items-start gap-3 leading-5" role="alert">
            <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
            <div class="min-w-0">
              <div class="font-medium">{__("Attention")}</div>
              <p class="mt-0.5 text-sm">{__("Your account is already verified if you changed your name you will lose the verification badge")}</p>
            </div>
          </div>
        {/if}

        <!-- basic info -->
        <section class="flex flex-col gap-4">
          <h3 class="flex items-center gap-2 text-sm font-semibold">
            <span class="icon-[tabler--id-badge-2] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Basic Info")}
          </h3>
          <div class="grid gap-6 sm:grid-cols-2">
            {if !$system['show_usernames_enabled']}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="firstname">{__("First Name")}</label>
                <input type="text" class="input w-full" id="firstname" name="firstname" autocomplete="given-name" value="{$user->_data['user_firstname']}">
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="lastname">{__("Last Name")}</label>
                <input type="text" class="input w-full" id="lastname" name="lastname" autocomplete="family-name" value="{$user->_data['user_lastname']}">
              </div>
            {/if}

            {if !$system['genders_disabled']}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="gender">{__("I am")}</label>
                <select class="select w-full" id="gender" name="gender">
                  <option value="none">{__("Select Sex")}</option>
                  {foreach $genders as $gender}
                    <option {if $user->_data['user_gender'] == $gender['gender_id']}selected{/if} value="{$gender['gender_id']}">{$gender['gender_name']}</option>
                  {/foreach}
                </select>
              </div>
            {/if}

            {if $system['relationship_info_enabled']}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="relationship">{__("Relationship Status")}</label>
                <select class="select w-full" id="relationship" name="relationship">
                  <option value="none">{__("Select Relationship")}</option>
                  <option {if $user->_data['user_relationship'] == "single"}selected{/if} value="single">{__("Single")}</option>
                  <option {if $user->_data['user_relationship'] == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
                  <option {if $user->_data['user_relationship'] == "married"}selected{/if} value="married">{__("Married")}</option>
                  <option {if $user->_data['user_relationship'] == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
                  <option {if $user->_data['user_relationship'] == "separated"}selected{/if} value="separated">{__("Separated")}</option>
                  <option {if $user->_data['user_relationship'] == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
                  <option {if $user->_data['user_relationship'] == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
                </select>
              </div>
            {/if}

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="country">{__("Country")}</label>
              <select class="select w-full" id="country" name="country">
                <option value="none">{__("Select Country")}</option>
                {foreach $countries as $country}
                  <option {if $user->_data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                {/foreach}
              </select>
            </div>

            {if $system['website_info_enabled']}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="website">{__("Website")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--link] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="website" name="website" value="{$user->_data['user_website']}" placeholder="https://" dir="ltr">
                </div>
                <span class="helper-text">{__("Website link must start with http:// or https://")}</span>
              </div>
            {/if}
          </div>
        </section>
        <!-- basic info -->

        <!-- birthdate -->
        <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
          <h3 class="flex items-center gap-2 text-sm font-semibold">
            <span class="icon-[tabler--cake] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Birthdate")}
          </h3>
          <div class="w-full">
            <div class="grid gap-4 sm:grid-cols-3">
              <select class="select w-full" id="birth_month" name="birth_month" aria-label='{__("Select Month")}'>
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
              <select class="select w-full" id="birth_day" name="birth_day" aria-label='{__("Select Day")}'>
                <option value="none">{__("Select Day")}</option>
                {for $i=1 to 31}
                  <option {if $user->_data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
                {/for}
              </select>
              <select class="select w-full" id="birth_year" name="birth_year" aria-label='{__("Select Year")}'>
                <option value="none">{__("Select Year")}</option>
                {for $i=1905 to $smarty.now|date_format:"%Y"}
                  <option {if $user->_data['user_birthdate_parsed']['year'] == $i}selected{/if} value="{$i}">{$i}</option>
                {/for}
              </select>
            </div>
          </div>
        </section>
        <!-- birthdate -->

        <!-- about me -->
        {if $system['biography_info_enabled']}
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
            <h3 class="flex items-center gap-2 text-sm font-semibold">
              <label class="flex items-center gap-2" for="biography">
                <span class="icon-[tabler--quote] size-5 text-base-content/60" aria-hidden="true"></span>
                {__("About Me")}
              </label>
            </h3>
            <textarea class="textarea w-full" id="biography" name="biography" rows="4" dir="auto">{$user->_data['user_biography']}</textarea>
          </section>
        {/if}
        <!-- about me -->

        <!-- custom fields -->
        {if $custom_fields['basic']}
          <section class="flex flex-col gap-6 border-t border-base-300 pt-6">
            {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
          </section>
        {/if}
        <!-- custom fields -->

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{elseif $sub_view == "work"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=work">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--briefcase]" _title=__("Work") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="work_title">{__("Work Title")}</label>
          <div class="input w-full items-center gap-2">
            <span class="icon-[tabler--id-badge-2] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <input type="text" class="grow" id="work_title" name="work_title" value="{$user->_data['user_work_title']}" autocomplete="organization-title">
          </div>
        </div>

        <div class="grid gap-6 sm:grid-cols-2">
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="work_place">{__("Work Place")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--building] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="text" class="grow" id="work_place" name="work_place" value="{$user->_data['user_work_place']}" autocomplete="organization">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="work_url">{__("Work Website")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--link] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="text" class="grow" id="work_url" name="work_url" value="{$user->_data['user_work_url']}" placeholder="https://" dir="ltr">
            </div>
            <span class="helper-text">{__("Website link must start with http:// or https://")}</span>
          </div>
        </div>

        <!-- custom fields -->
        {if $custom_fields['work']}
          <section class="flex flex-col gap-6 border-t border-base-300 pt-6">
            {include file='__custom_fields.tpl' _custom_fields=$custom_fields['work'] _registration=false}
          </section>
        {/if}
        <!-- custom fields -->

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{elseif $sub_view == "location"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=location">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--map-pin]" _title=__("Location") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        <div class="grid gap-6 sm:grid-cols-2">
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="city">{__("Current City")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--map-pin] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="text" class="grow js_geocomplete" id="city" name="city" value="{$user->_data['user_current_city']}" autocomplete="off">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="hometown">{__("Hometown")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--home] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="text" class="grow js_geocomplete" id="hometown" name="hometown" value="{$user->_data['user_hometown']}" autocomplete="off">
            </div>
          </div>
        </div>

        <!-- custom fields -->
        {if $custom_fields['location']}
          <section class="flex flex-col gap-6 border-t border-base-300 pt-6">
            {include file='__custom_fields.tpl' _custom_fields=$custom_fields['location'] _registration=false}
          </section>
        {/if}
        <!-- custom fields -->

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{elseif $sub_view == "education"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=education">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--school]" _title=__("Education") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="edu_school">{__("School")}</label>
          <div class="input w-full items-center gap-2">
            <span class="icon-[tabler--building-community] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <input type="text" class="grow" id="edu_school" name="edu_school" value="{$user->_data['user_edu_school']}">
          </div>
        </div>

        <div class="grid gap-6 sm:grid-cols-2">
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="edu_major">{__("Major")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--book] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="text" class="grow" id="edu_major" name="edu_major" value="{$user->_data['user_edu_major']}">
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

        <!-- custom fields -->
        {if $custom_fields['education']}
          <section class="flex flex-col gap-6 border-t border-base-300 pt-6">
            {include file='__custom_fields.tpl' _custom_fields=$custom_fields['education'] _registration=false}
          </section>
        {/if}
        <!-- custom fields -->

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{elseif $sub_view == "other"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=other">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--dots]" _title=__("Other") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        {if $custom_fields['other']}
          <!-- custom fields -->
          <div class="grid gap-6 sm:grid-cols-2">
            {include file='__custom_fields.tpl' _custom_fields=$custom_fields['other'] _registration=false}
          </div>
          <!-- custom fields -->

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        {else}
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--forms]"}
        {/if}
      </div>
      {if $custom_fields['other']}
        <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
          <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
        </div>
      {/if}
    </form>
  </div>

{elseif $sub_view == "social"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=social">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--share]" _title=__("Social Links") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        <div class="grid gap-6 sm:grid-cols-2">
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="facebook">{__("Facebook Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="facebook" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="facebook" name="facebook" value="{$user->_data['user_social_facebook']}" placeholder="https://facebook.com/" dir="ltr">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="twitter">{__("X Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="x" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="twitter" name="twitter" value="{$user->_data['user_social_twitter']}" placeholder="https://x.com/" dir="ltr">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="youtube">{__("YouTube Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="youtube" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="youtube" name="youtube" value="{$user->_data['user_social_youtube']}" placeholder="https://youtube.com/@" dir="ltr">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="instagram">{__("Instagram Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="instagram" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="instagram" name="instagram" value="{$user->_data['user_social_instagram']}" placeholder="https://instagram.com/" dir="ltr">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="twitch">{__("Twitch Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="twitch" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="twitch" name="twitch" value="{$user->_data['user_social_twitch']}" placeholder="https://twitch.tv/" dir="ltr">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="linkedin">{__("LinkedIn Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="linkedin" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="linkedin" name="linkedin" value="{$user->_data['user_social_linkedin']}" placeholder="https://linkedin.com/in/" dir="ltr">
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="vkontakte">{__("Vkontakte Profile URL")}</label>
            <div class="input w-full items-center gap-2">
              <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="vk" width="20px" height="20px"}
              </span>
              <input type="text" class="grow" id="vkontakte" name="vkontakte" value="{$user->_data['user_social_vkontakte']}" placeholder="https://vk.com/" dir="ltr">
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{elseif $sub_view == "design"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=design">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--palette]" _title=__("Design") _text=__("Your name, work, location, and how you look")}
      <div class="card-body gap-6 pt-6">
        <!-- profile background -->
        <section class="flex flex-col gap-4">
          <h3 class="flex items-center gap-2 text-sm font-semibold" id="profile-background-label">
            <span class="icon-[tabler--photo] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Profile Background")}
          </h3>
          {include file='__x_image.tpl' _x_name="user_profile_background" _x_value=$user->_data['user_profile_background'] _x_class="aspect-[3/1] min-h-40 w-full"}
        </section>
        <!-- profile background -->

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{/if}
