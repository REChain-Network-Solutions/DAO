<section class="admin-settings-page" aria-labelledby="settings-limits-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-limits-title" class="text-2xl font-semibold">{__("Limits Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Heartbeats, rate limits, and presence.")}</p>
  </div>
  <form class="js_ajax-forms" data-url="admin/settings.php?edit=limits">
    <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="data_heartbeat">{__("Data Heartbeat")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="data_heartbeat" id="data_heartbeat" value="{$system['data_heartbeat']}" aria-describedby="data_heartbeat-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="data_heartbeat-help">{__("The update interval to check for new data (in seconds)")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="chat_heartbeat">{__("Chat Heartbeat")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="chat_heartbeat" id="chat_heartbeat" value="{$system['chat_heartbeat']}" aria-describedby="chat_heartbeat-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="chat_heartbeat-help">{__("The update interval to check for new messages (in seconds)")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="offline_time">{__("Offline After")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="offline_time" id="offline_time" value="{$system['offline_time']}" aria-describedby="offline_time-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="offline_time-help">
                  {__("The amount of time to be considered online since the last user's activity (in seconds)")}<br>
                  {__("The maximim value is one day = 86400 seconds")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="newsfeed_results">{__("Newsfeed Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="newsfeed_results" id="newsfeed_results" value="{$system['newsfeed_results']}" aria-describedby="newsfeed_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="newsfeed_results-help">{__("The number of posts in the newsfeed")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="people_results">{__("People Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="people_results" id="people_results" value="{$system['people_results']}" aria-describedby="people_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="people_results-help">{__("The number of results in the people module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="pages_results">{__("Pages Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="pages_results" id="pages_results" value="{$system['pages_results']}" aria-describedby="pages_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="pages_results-help">{__("The number of results in the pages module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="groups_results">{__("Groups Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="groups_results" id="groups_results" value="{$system['groups_results']}" aria-describedby="groups_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="groups_results-help">{__("The number of results in the groups module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="events_results">{__("Events Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="events_results" id="events_results" value="{$system['events_results']}" aria-describedby="events_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="events_results-help">{__("The number of results in the events module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="watch_results">{__("Watch Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="watch_results" id="watch_results" value="{$system['watch_results']}" aria-describedby="watch_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="watch_results-help">{__("The number of results in the watch module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="live_results">{__("Live Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="live_results" id="live_results" value="{$system['live_results']}" aria-describedby="live_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="live_results-help">{__("The number of results in the live module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="blogs_results">{__("Blogs Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="blogs_results" id="blogs_results" value="{$system['blogs_results']}" aria-describedby="blogs_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="blogs_results-help">{__("The number of results in the blogs module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="marketplace_results">{__("Marketplace Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="marketplace_results" id="marketplace_results" value="{$system['marketplace_results']}" aria-describedby="marketplace_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="marketplace_results-help">{__("The number of results in the marketplace module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="funding_results">{__("Funding Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="funding_results" id="funding_results" value="{$system['funding_results']}" aria-describedby="funding_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="funding_results-help">{__("The number of results in the funding module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="offers_results">{__("Offers Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="offers_results" id="offers_results" value="{$system['offers_results']}" aria-describedby="offers_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="offers_results-help">{__("The number of results in the offers module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="jobs_results">{__("Jobs Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="jobs_results" id="jobs_results" value="{$system['jobs_results']}" aria-describedby="jobs_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="jobs_results-help">{__("The number of results in the jobs module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="dating_results">{__("Dating Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="dating_results" id="dating_results" value="{$system['dating_results']}" aria-describedby="dating_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="dating_results-help">{__("The number of results in the dating module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="courses_results">{__("Courses Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="courses_results" id="courses_results" value="{$system['courses_results']}" aria-describedby="courses_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="courses_results-help">{__("The number of results in the courses module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="movies_results">{__("Movies Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="movies_results" id="movies_results" value="{$system['movies_results']}" aria-describedby="movies_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="movies_results-help">{__("The number of results in the movies module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="games_results">{__("Games Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="games_results" id="games_results" value="{$system['games_results']}" aria-describedby="games_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="games_results-help">{__("The number of results in the games module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="search_results">{__("Search Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="search_results" id="search_results" value="{$system['search_results']}" aria-describedby="search_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="search_results-help">{__("The number of results in the search module")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="min_results">{__("Minimum Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="min_results" id="min_results" value="{$system['min_results']}" aria-describedby="min_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="min_results-help">{__("The Min number of results per request")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="max_results">{__("Maximum Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="max_results" id="max_results" value="{$system['max_results']}" aria-describedby="max_results-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="max_results-help">{__("The Max number of results per request")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="min_results_even">{__("Minimum Even Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="min_results_even" id="min_results_even" value="{$system['min_results_even']}" aria-describedby="min_results_even-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="min_results_even-help">{__("The Min even number of results per request")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="max_results_even">{__("Maximum Even Results")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="max_results_even" id="max_results_even" value="{$system['max_results_even']}" aria-describedby="max_results_even-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="max_results_even-help">{__("The Max even number of results per request")}</div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </div>
    </div>
  </form>
</section>
