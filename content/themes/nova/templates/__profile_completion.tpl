<!-- panel [profile completion] -->
{if isset($profile['profile_completion']) && $profile['profile_completion'] < 100}
  <section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
    {include file='__card_header.tpl' _card_title=__("Complete your profile")}
    <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
      {$_completion_left = 0}
      {$_completion_done = 0}
      {capture name="completion_left"}
        {if $system['verification_for_posts'] && (!$profile['user_verified'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/verification">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Verify your account to add content")}">{__("Verify your account to add content")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
        {if ($profile['user_picture_default'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <button type="button" class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40 js_profile-image-trigger">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your profile picture")}">{__("Add your profile picture")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </button>
          </li>
        {/if}
        {if ($profile['user_cover_default'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <button type="button" class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40 js_profile-cover-trigger">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your profile cover")}">{__("Add your profile cover")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </button>
          </li>
        {/if}
        {if $system['biography_info_enabled'] && (!$profile['user_biography'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/profile">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your biography")}">{__("Add your biography")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
        {if (!$profile['user_birthdate'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/profile">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your birthdate")}">{__("Add your birthdate")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
        {if $system['relationship_info_enabled'] && (!$profile['user_relationship'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/profile">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your relationship")}">{__("Add your relationship")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
        {if $system['work_info_enabled'] && (!$profile['user_work_title'] || !$profile['user_work_place'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/profile/work">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your work info")}">{__("Add your work info")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
        {if $system['location_info_enabled'] && (!$profile['user_current_city'] || !$profile['user_hometown'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/profile/location">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your location info")}">{__("Add your location info")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
        {if $system['education_info_enabled'] && (!$profile['user_edu_major'] || !$profile['user_edu_school'])}
          {$_completion_left = $_completion_left + 1}
          <li>
            <a class="group flex h-12 w-full items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-100 ps-4 pe-2 text-start text-base-content! transition-colors hover:border-primary/40" href="{$system['system_url']}/settings/profile/education">
              <span class="icon-[tabler--circle-check] size-5.5 shrink-0 text-base-content/30" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 truncate text-sm font-medium" title="{__("Add your education info")}">{__("Add your education info")}</span>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl border border-primary/40 text-primary transition-colors group-hover:border-primary group-hover:bg-primary group-hover:text-primary-content"><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></span>
            </a>
          </li>
        {/if}
      {/capture}
      {capture name="completion_done"}
        {if $system['verification_for_posts'] && !(!$profile['user_verified'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Verify your account to add content")}">{__("Verify your account to add content")}</span>
          </li>
        {/if}
        {if !($profile['user_picture_default'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your profile picture")}">{__("Add your profile picture")}</span>
          </li>
        {/if}
        {if !($profile['user_cover_default'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your profile cover")}">{__("Add your profile cover")}</span>
          </li>
        {/if}
        {if $system['biography_info_enabled'] && !(!$profile['user_biography'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your biography")}">{__("Add your biography")}</span>
          </li>
        {/if}
        {if !(!$profile['user_birthdate'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your birthdate")}">{__("Add your birthdate")}</span>
          </li>
        {/if}
        {if $system['relationship_info_enabled'] && !(!$profile['user_relationship'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your relationship")}">{__("Add your relationship")}</span>
          </li>
        {/if}
        {if $system['work_info_enabled'] && !(!$profile['user_work_title'] || !$profile['user_work_place'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your work info")}">{__("Add your work info")}</span>
          </li>
        {/if}
        {if $system['location_info_enabled'] && !(!$profile['user_current_city'] || !$profile['user_hometown'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your location info")}">{__("Add your location info")}</span>
          </li>
        {/if}
        {if $system['education_info_enabled'] && !(!$profile['user_edu_major'] || !$profile['user_edu_school'])}
          {$_completion_done = $_completion_done + 1}
          <li class="flex h-12 items-center gap-3 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl border border-base-300 bg-base-200/50 px-4">
            <span class="icon-[tabler--circle-check-filled] size-5.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="min-w-0 flex-1 truncate text-sm text-base-content/50 line-through" title="{__("Add your education info")}">{__("Add your education info")}</span>
          </li>
        {/if}
      {/capture}
      <p class="text-sm leading-relaxed text-base-content/60">{__("A complete profile helps people find and connect with you")}</p>
      <div class="flex items-center gap-3">
        <span class="text-base font-bold tabular-nums">{$profile['profile_completion']}%</span>
        <div class="h-2.5 flex-1 overflow-hidden rounded-full bg-base-200" role="progressbar" aria-valuenow="{$profile['profile_completion']}" aria-valuemin="0" aria-valuemax="100">
          <div class="h-full rounded-full bg-success" style="width: {$profile['profile_completion']}%"></div>
        </div>
      </div>
      <ul class="space-y-2 border-t border-base-300 pt-4">
        {$smarty.capture.completion_left nofilter}
        {$smarty.capture.completion_done nofilter}
      </ul>
    </div>
  </section>
{/if}
<!-- panel [profile completion] -->
