<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("System")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#General" data-bs-toggle="tab">
        <i class="fa fa-server fa-fw mr5"></i><strong>{__("General")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#SEO" data-bs-toggle="tab">
        <i class="fa fa-sitemap fa-fw mr5"></i><strong>{__("SEO")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Modules" data-bs-toggle="tab">
        <i class="fa fa-dice-d6 fa-fw mr5"></i><strong>{__("Modules")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Features" data-bs-toggle="tab">
        <i class="fa fa-microchip fa-fw mr5"></i><strong>{__("Features")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tab-content -->
<div class="tab-content">
  <!-- General -->
  <div class="tab-pane active" id="General">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=general">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="website_live" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Website Live")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the entire website On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="system_live">
              <input type="checkbox" name="system_live" id="system_live" {if $system['system_live']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Shutdown Message")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_message" rows="3">{$system['system_message']}</textarea>
            <div class="form-text">
              {__("The text that is presented when the site is closed")}
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("System Email")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="system_email" value="{$system['system_email']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("The contact email that all messages send to")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("System Datetime Format")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="system_datetime_format">
              <option {if $system['system_datetime_format'] == "d/m/Y H:i"}selected{/if} value="d/m/Y H:i">d/m/Y H:i ({__("Example")}: 30/05/2023 01:30 PM)</option>
              <option {if $system['system_datetime_format'] == "m/d/Y H:i"}selected{/if} value="m/d/Y H:i">m/d/Y H:i ({__("Example")}: 05/30/2023 01:30 PM)</option>
            </select>
            <div class="form-text">
              {__("Select the datetime format of the datetime picker")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("System Distance Unit")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="system_distance">
              <option {if $system['system_distance'] == "mile"}selected{/if} value="mile">{__("Mile")}</option>
              <option {if $system['system_distance'] == "kilometer"}selected{/if} value="kilometer">{__("Kilometer")}</option>
            </select>
            <div class="form-text">
              {__("Select the distance measure unit of your website")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("System Currency")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="system_currency">
              {foreach $system_currencies as $currency}
                <option {if $currency['default']}selected{/if} value="{$currency['currency_id']}">
                  {$currency['name']} ({$currency['code']})
                </option>
              {/foreach}
            </select>
            <div class="form-text">
              {__("You can add, edit or delete currencies from")} <a href="{$system['system_url']}/{$control_panel['url']}/currencies">{__("Currencies")}</a>
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
  </div>
  <!-- General -->

  <!-- SEO -->
  <div class="tab-pane" id="SEO">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=seo">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="website_public" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Website Public")}</div>
            <div class="form-text d-none d-sm-block">{__("Make the website public to allow non logged users to view website content")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="system_public">
              <input type="checkbox" name="system_public" id="system_public" {if $system['system_public']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Newsfeed Public")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Make the newsfeed available for visitors in landing page")}<br>
              {__("Enable this will make your website public and list only public posts")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="newsfeed_public">
              <input type="checkbox" name="newsfeed_public" id="newsfeed_public" {if $system['newsfeed_public']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="directory" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6"> {__("Directory")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable the directory for better SEO results")}<br>
              {__("Make the website public to allow non logged users to view website content")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="directory_enabled">
              <input type="checkbox" name="directory_enabled" id="directory_enabled" {if $system['directory_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Website Title")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="system_title" value="{__($system['system_title'])}">
            <div class="form-text">
              {__("Title of your website")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Website Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description" rows="3">{$system['system_description']}</textarea>
            <div class="form-text">
              {__("Description of your website")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Website Keywords")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_keywords" rows="3">{$system['system_keywords']}</textarea>
            <div class="form-text">
              {__("Example: social, social site")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Directory Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_directory" rows="3">{$system['system_description_directory']}</textarea>
            <div class="form-text">
              {__("Description of your Directory")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Pages Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_pages" rows="3">{$system['system_description_pages']}</textarea>
            <div class="form-text">
              {__("Description of your pages module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Groups Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_groups" rows="3">{$system['system_description_groups']}</textarea>
            <div class="form-text">
              {__("Description of your groups module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Events Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_events" rows="3">{$system['system_description_events']}</textarea>
            <div class="form-text">
              {__("Description of your events module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watch Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_watch" rows="3">{$system['system_description_watch']}</textarea>
            <div class="form-text">
              {__("Description of your watch module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Blogs Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_blogs" rows="3">{$system['system_description_blogs']}</textarea>
            <div class="form-text">
              {__("Description of your blogs module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Marketplace Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_marketplace" rows="3">{$system['system_description_marketplace']}</textarea>
            <div class="form-text">
              {__("Description of your marketplace module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Funding Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_funding" rows="3">{$system['system_description_funding']}</textarea>
            <div class="form-text">
              {__("Description of your funding module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Offers Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_offers" rows="3">{$system['system_description_offers']}</textarea>
            <div class="form-text">
              {__("Description of your offer module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Jobs Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_jobs" rows="3">{$system['system_description_jobs']}</textarea>
            <div class="form-text">
              {__("Description of your jobs module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Courses Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_courses" rows="3">{$system['system_description_courses']}</textarea>
            <div class="form-text">
              {__("Description of your courses module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Forums Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_forums" rows="3">{$system['system_description_forums']}</textarea>
            <div class="form-text">
              {__("Description of your forums module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Movies Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_movies" rows="3">{$system['system_description_movies']}</textarea>
            <div class="form-text">
              {__("Description of your movies module")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Games Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_description_games" rows="3">{$system['system_description_games']}</textarea>
            <div class="form-text">
              {__("Description of your games module")}
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
  </div>
  <!-- SEO -->

  <!-- Modules -->
  <div class="tab-pane" id="Modules">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=modules">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Pages")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the pages On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="pages_enabled">
              <input type="checkbox" name="pages_enabled" id="pages_enabled" {if $system['pages_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="star" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Pages Reviews")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the pages reviews On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="pages_reviews_enabled">
              <input type="checkbox" name="pages_reviews_enabled" id="pages_reviews_enabled" {if $system['pages_reviews_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Pages Review Replacement")}</div>
            <div class="form-text d-none d-sm-block">{__("Enbale this to allow user to change his review")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="pages_reviews_replacement_enabled">
              <input type="checkbox" name="pages_reviews_replacement_enabled" id="pages_reviews_replacement_enabled" {if $system['pages_reviews_replacement_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="user_information" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Pages Business ID (PBID)")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the page business ID On and Off")}<br>
              {__("PBID is a unique ID for each page consists of 16 digits from country code and category id and page id")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="pages_pbid_enabled">
              <input type="checkbox" name="pages_pbid_enabled" id="pages_pbid_enabled" {if $system['pages_pbid_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Pages Country Filter")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the pages country filter On and Off")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="pages_location_filter_enabled">
              <input type="checkbox" name="pages_location_filter_enabled" id="pages_location_filter_enabled" {if $system['pages_location_filter_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Groups")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the groups On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="groups_enabled">
              <input type="checkbox" name="groups_enabled" id="groups_enabled" {if $system['groups_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="star" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Groups Reviews")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the groups reviews On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="groups_reviews_enabled">
              <input type="checkbox" name="groups_reviews_enabled" id="groups_reviews_enabled" {if $system['groups_reviews_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Groups Review Replacement")}</div>
            <div class="form-text d-none d-sm-block">{__("Enbale this to allow user to change his review")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="groups_reviews_replacement_enabled">
              <input type="checkbox" name="groups_reviews_replacement_enabled" id="groups_reviews_replacement_enabled" {if $system['groups_reviews_replacement_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Groups Country Filter")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the groups country filter On and Off")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="groups_location_filter_enabled">
              <input type="checkbox" name="groups_location_filter_enabled" id="groups_location_filter_enabled" {if $system['groups_location_filter_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="events" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Events")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the events On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="events_enabled">
              <input type="checkbox" name="events_enabled" id="events_enabled" {if $system['events_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Pages Events")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow pages to create events")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="pages_events_enabled">
              <input type="checkbox" name="pages_events_enabled" id="pages_events_enabled" {if $system['pages_events_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="star" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Events Reviews")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the events reviews On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="events_reviews_enabled">
              <input type="checkbox" name="events_reviews_enabled" id="events_reviews_enabled" {if $system['events_reviews_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Events Review Replacement")}</div>
            <div class="form-text d-none d-sm-block">{__("Enbale this to allow user to change his review")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="events_reviews_replacement_enabled">
              <input type="checkbox" name="events_reviews_replacement_enabled" id="events_reviews_replacement_enabled" {if $system['events_reviews_replacement_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Events Country Filter")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the events country filter On and Off")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="events_location_filter_enabled">
              <input type="checkbox" name="events_location_filter_enabled" id="events_location_filter_enabled" {if $system['events_location_filter_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="reels" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Reels")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the reels On and Off")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="reels_enabled">
              <input type="checkbox" name="reels_enabled" id="reels_enabled" {if $system['reels_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="watch" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Watch")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the watch videos On and Off")}<br>
              {__("Watch module will show all public videos at one place")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="watch_enabled">
              <input type="checkbox" name="watch_enabled" id="watch_enabled" {if $system['watch_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Blogs")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the blogs On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="blogs_enabled">
              <input type="checkbox" name="blogs_enabled" id="blogs_enabled" {if $system['blogs_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="widget" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Blogs Widget")}</div>
            <div class="form-text d-none d-sm-block">{__("Enbale latest blogs carousel widget to be displayed on the home page")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="blogs_widget_enabled">
              <input type="checkbox" name="blogs_widget_enabled" id="blogs_widget_enabled" {if $system['blogs_widget_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Offers")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the offers On and Off")}<br>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="offers_enabled">
              <input type="checkbox" name="offers_enabled" id="offers_enabled" {if $system['offers_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="jobs" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Jobs")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the jobs On and Off")}<br>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="jobs_enabled">
              <input type="checkbox" name="jobs_enabled" id="jobs_enabled" {if $system['jobs_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="courses" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Courses")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the courses On and Off")}<br>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="courses_enabled">
              <input type="checkbox" name="courses_enabled" id="courses_enabled" {if $system['courses_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="forums" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Forums")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the forums On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="forums_enabled">
              <input type="checkbox" name="forums_enabled" id="forums_enabled" {if $system['forums_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="user_online" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Online Users")}</div>
            <div class="form-text d-none d-sm-block">{__("Show forums online users")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="forums_online_enabled">
              <input type="checkbox" name="forums_online_enabled" id="forums_online_enabled" {if $system['forums_online_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="stats" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Statistics")}</div>
            <div class="form-text d-none d-sm-block">{__("Show forums statistics")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="forums_statistics_enabled">
              <input type="checkbox" name="forums_statistics_enabled" id="forums_statistics_enabled" {if $system['forums_statistics_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="movies" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Movies")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the movies On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="movies_enabled">
              <input type="checkbox" name="movies_enabled" id="movies_enabled" {if $system['movies_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="games" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Games")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the games On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="games_enabled">
              <input type="checkbox" name="games_enabled" id="games_enabled" {if $system['games_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
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
  </div>
  <!-- Modules -->

  <!-- Features -->
  <div class="tab-pane" id="Features">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=features">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="language" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Auto Language Detection")}</div>
            <div class="form-text d-none d-sm-block">{__("If enabled sytem will detect user language automatically")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="auto_language_detection">
              <input type="checkbox" name="auto_language_detection" id="auto_language_detection" {if $system['auto_language_detection']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Fliter by Geolocation")}</div>
            <div class="form-text d-none d-sm-block">
              {__("If enabled user will able to filter people, products ... etc by Geolocation")}<br>
              {__("System will use your browser's geolocation feature to detect the user's current location (latitude and longitude)")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="location_finder_enabled">
              <input type="checkbox" name="location_finder_enabled" id="location_finder_enabled" {if $system['location_finder_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="contat_us" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Contact Us")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the contact us page On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="contact_enabled">
              <input type="checkbox" name="contact_enabled" id="contact_enabled" {if $system['contact_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="support" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Support Center")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the support tickets center On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="support_center_enabled">
              <input type="checkbox" name="support_center_enabled" id="support_center_enabled" {if $system['support_center_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="dark_light" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("DayTime Messages")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the DayTime Messages (Good Morning, Afternoon, Evening) On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="daytime_msg_enabled">
              <input type="checkbox" name="daytime_msg_enabled" id="daytime_msg_enabled" {if $system['daytime_msg_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Morning Message")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_morning_message" rows="3">{$system['system_morning_message']}</textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Afternoon Message")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_afternoon_message" rows="3">{$system['system_afternoon_message']}</textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Evening Message")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="system_evening_message" rows="3">{$system['system_evening_message']}</textarea>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="poke" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Pokes")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable users to poke each others")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="pokes_enabled">
              <input type="checkbox" name="pokes_enabled" id="pokes_enabled" {if $system['pokes_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="gifts" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Gifts")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable users to send gifts to each others")}<br>
              {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/gifts">{__("Gifts")}</a>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="gifts_enabled">
              <input type="checkbox" name="gifts_enabled" id="gifts_enabled" {if $system['gifts_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="points" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Gifts with Points")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable users to send gifts with points to each others")}<br>
              {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/points">{__("Points System")}</a>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="gifts_points_enabled">
              <input type="checkbox" name="gifts_points_enabled" id="gifts_points_enabled" {if $system['gifts_points_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="cookie" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Cookie Consent")} ({__("GDPR")})</div>
            <div class="form-text d-none d-sm-block">{__("Turn the cookie consent notification On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="cookie_consent_enabled">
              <input type="checkbox" name="cookie_consent_enabled" id="cookie_consent_enabled" {if $system['cookie_consent_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="adblock" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Adblock Detector")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the Adblock auto detector notification On and Off")}, {__("(Note: Admin is exception)")}<br>
              {__("Red block message will appear to make user disable adblock from his browser")}<br>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="adblock_detector_enabled">
              <input type="checkbox" name="adblock_detector_enabled" id="adblock_detector_enabled" {if $system['adblock_detector_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
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
  </div>
  <!-- Features -->
</div>
<!-- tab-content -->