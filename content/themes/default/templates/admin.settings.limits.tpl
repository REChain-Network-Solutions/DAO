<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Limits")}
  <!-- panel title -->
</div>
<!-- card-header -->

<!-- Limits -->
<form class="js_ajax-forms" data-url="admin/settings.php?edit=limits">
  <div class="card-body">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Data Heartbeat")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="data_heartbeat" value="{$system['data_heartbeat']}">
        <div class="form-text">
          {__("The update interval to check for new data (in seconds)")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Chat Heartbeat")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="chat_heartbeat" value="{$system['chat_heartbeat']}">
        <div class="form-text">
          {__("The update interval to check for new messages (in seconds)")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Offline After")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="offline_time" value="{$system['offline_time']}">
        <div class="form-text">
          {__("The amount of time to be considered online since the last user's activity (in seconds)")}<br>
          {__("The maximim value is one day = 86400 seconds")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Newsfeed Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="newsfeed_results" value="{$system['newsfeed_results']}">
        <div class="form-text">
          {__("The number of posts in the newsfeed")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Pages Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="pages_results" value="{$system['pages_results']}">
        <div class="form-text">
          {__("The number of results in the pages module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Groups Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="groups_results" value="{$system['groups_results']}">
        <div class="form-text">
          {__("The number of results in the groups module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Events Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="events_results" value="{$system['events_results']}">
        <div class="form-text">
          {__("The number of results in the events module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Blogs Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="blogs_results" value="{$system['blogs_results']}">
        <div class="form-text">
          {__("The number of results in the blogs module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Marketplace Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="marketplace_results" value="{$system['marketplace_results']}">
        <div class="form-text">
          {__("The number of results in the marketplace module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Funding Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="funding_results" value="{$system['funding_results']}">
        <div class="form-text">
          {__("The number of results in the funding module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Offers Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="offers_results" value="{$system['offers_results']}">
        <div class="form-text">
          {__("The number of results in the offers module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Jobs Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="jobs_results" value="{$system['jobs_results']}">
        <div class="form-text">
          {__("The number of results in the jobs module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Courses Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="courses_results" value="{$system['courses_results']}">
        <div class="form-text">
          {__("The number of results in the courses module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Games Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="games_results" value="{$system['games_results']}">
        <div class="form-text">
          {__("The number of results in the games module")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Search Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="search_results" value="{$system['search_results']}">
        <div class="form-text">
          {__("The number of results in the search module")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Minimum Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="min_results" value="{$system['min_results']}">
        <div class="form-text">
          {__("The Min number of results per request")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Maximum Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="max_results" value="{$system['max_results']}">
        <div class="form-text">
          {__("The Max number of results per request")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Minimum Even Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="min_results_even" value="{$system['min_results_even']}">
        <div class="form-text">
          {__("The Min even number of results per request")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Maximum Even Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="max_results_even" value="{$system['max_results_even']}">
        <div class="form-text">
          {__("The Max even number of results per request")}
        </div>
      </div>
    </div>

    <!-- success -->
    <div class="alert alert-success mt15 mb0 x-hidden"></div>
    <!-- success -->

    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="card-footer text-end">
    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
  </div>
</form>
<!-- Limits -->