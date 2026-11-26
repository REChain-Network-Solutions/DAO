<div class="card border border-base-300 bg-base-100 shadow-none">
  <form class="js_ajax-forms" data-url="users/information.php">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--file-download]" _title=__("Your Information") _text=__("Download a copy of your data")}
    <div class="card-body gap-6 pt-6">
      <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
        <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
        <div class="min-w-0">
          <div class="font-medium">{__("Download Your Information")}</div>
          <p class="mt-0.5 text-sm">{__("You can download all of it at once, or you can select only the types of information you want")}</p>
        </div>
      </div>

      <!-- download options -->
      <fieldset class="flex flex-col gap-3">
        <legend class="mb-3 text-sm font-semibold">{__("Select which information you would like to download")}</legend>
        <div class="grid gap-3 sm:grid-cols-2">
          <!-- Info -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_information">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="user_information" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Info")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_information" id="download_information">
          </label>
          <!-- Info -->
          <!-- Friends -->
          {if $system['friends_enabled']}
            <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_friends">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="friends" class="main-icon" width="24px" height="24px"}
              </span>
              <span class="min-w-0 grow text-sm font-medium">{__("Friends")}</span>
              <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_friends" id="download_friends">
            </label>
          {/if}
          <!-- Friends -->
          <!-- Followings -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_followings">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="followings" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Followings")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_followings" id="download_followings">
          </label>
          <!-- Followings -->
          <!-- Followers -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_followers">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="followers" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Followers")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_followers" id="download_followers">
          </label>
          <!-- Followers -->
          <!-- Pages -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_pages">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Pages")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_pages" id="download_pages">
          </label>
          <!-- Pages -->
          <!-- Groups -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_groups">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Groups")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_groups" id="download_groups">
          </label>
          <!-- Groups -->
          <!-- Events -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_events">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="events" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Events")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_events" id="download_events">
          </label>
          <!-- Events -->
          <!-- Posts -->
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="download_posts">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="24px" height="24px"}
            </span>
            <span class="min-w-0 grow text-sm font-medium">{__("Posts")}</span>
            <input class="checkbox checkbox-primary shrink-0" type="checkbox" name="download_posts" id="download_posts">
          </label>
          <!-- Posts -->
        </div>
      </fieldset>
      <!-- download options -->

      <!-- success -->
      <div class="alert alert-success hidden items-center" role="status"></div>
      <!-- success -->

      <!-- error -->
      <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
      <!-- error -->
    </div>
    <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
      <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--download] size-4" aria-hidden="true"></span>
        {__("Request")}
      </button>
    </div>
  </form>
</div>
