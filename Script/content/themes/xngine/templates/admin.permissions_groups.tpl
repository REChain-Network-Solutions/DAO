<div class="card">
  <div class="card-header with-icon">
    {if $sub_view == ""}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/add" class="btn btn-md btn-primary">
          <i class="fa fa-key mr5"></i>{__("Add New Group")}
        </a>
      </div>
    {elseif $sub_view == "add" || $sub_view == "edit"}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
        </a>
      </div>
    {/if}
    <i class="fa fa-key mr10"></i>{__("Permissions Groups")}
    {if $sub_view == "edit"} &rsaquo; {$data['permissions_group_title']}{/if}
    {if $sub_view == "add"} &rsaquo; {__("Add New Group")}{/if}
  </div>

  {if $sub_view == ""}

    <div class="card-body">
      <!-- System Permissions Groups (Users/Verified) -->
      <h6 class="card-title mb20">{__("System Permissions Groups")}</h6>

      <div class="heading-small mb20">
        {__("Moderators")}
      </div>
      <div class="pl-md-4">
        <div class="table-responsive">
          <table class="table table-striped table-bordered table-hover">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Title")}</th>
                <th>{__("Actions")}</th>
              </tr>
            </thead>
            <tbody>
              <!-- Users -->
              <tr>
                <td>1</td>
                <td>{__("Moderators Permissions")}</td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/mods" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                </td>
              </tr>
              <!-- Users -->
            </tbody>
          </table>
        </div>
      </div>

      <div class="heading-small mb20">
        {__("Users")}
      </div>
      <div class="pl-md-4">
        <div class="table-responsive">
          <table class="table table-striped table-bordered table-hover">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Title")}</th>
                <th>{__("Actions")}</th>
              </tr>
            </thead>
            <tbody>
              <!-- Users -->
              <tr>
                <td>1</td>
                <td>{__("Users Permissions")}</td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/users" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                </td>
              </tr>
              <!-- Users -->
              <!-- Verified -->
              <tr>
                <td>2</td>
                <td>{__("Verified Permissions")}</td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/verified" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                </td>
              </tr>
              <!-- Verified -->
            </tbody>
          </table>
        </div>
      </div>
      <!-- System Permissions Groups (Users/Verified) -->

      <div class="divider"></div>

      <!-- Custom Permissions Groups -->
      <h6 class="card-title mb20">{__("Custom Permissions Groups")}</h6>
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_dataTable">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Title")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>{$row['permissions_group_id']}</td>
                <td>
                  {$row['permissions_group_title']}
                </td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/{$row['permissions_group_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                  <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="permissions_group" data-id="{$row['permissions_group_id']}">
                    <i class="fa fa-trash-alt"></i>
                  </button>
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
      <!-- Custom Permissions Groups -->
    </div>

  {elseif $sub_view == "add"}

    <form class="js_ajax-forms" data-url="admin/permissions_groups.php?do=add">
      <div class="card-body">
        <div class="heading-small mb20">
          {__("Group Info")}
        </div>
        <div class="pl-md-4">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Group Title")}
            </label>
            <div class="col-md-9">
              <input class="form-control" name="title">
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Modules Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Pages Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Pages")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Create Pages")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="pages_permission">
                <input type="checkbox" name="pages_permission" id="pages_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Pages Permission -->

          <!-- Groups Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Groups")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Create Groups")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="groups_permission">
                <input type="checkbox" name="groups_permission" id="groups_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Groups Permission -->

          <!-- Events Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="events" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Events")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Create Events")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="events_permission">
                <input type="checkbox" name="events_permission" id="events_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Events Permission -->

          <!-- Reels Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="reels" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Reels")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Reels")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="reels_permission">
                <input type="checkbox" name="reels_permission" id="reels_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Reels Permission -->

          <!-- Watch Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="videos" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Videos")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Watch Videos")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="watch_permission">
                <input type="checkbox" name="watch_permission" id="watch_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Watch Permission -->

          <!-- Blogs Permission (Write) -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Blogs")} <span class="badge bg-light text-primary">{__("Write")}</span></div>
              <div class="form-text d-none d-sm-block">{__("Can Write Blogs")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="blogs_permission">
                <input type="checkbox" name="blogs_permission" id="blogs_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Blogs Permission (Write) -->

          <!-- Blogs Permission (Read) -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Blogs")} <span class="badge bg-light text-primary">{__("Read")}</span></div>
              <div class="form-text d-none d-sm-block">{__("Can Read Blogs")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="blogs_permission_read">
                <input type="checkbox" name="blogs_permission_read" id="blogs_permission_read">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Blogs Permission (Read) -->

          <!-- Market Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="market" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Market")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Sell Products")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="market_permission">
                <input type="checkbox" name="market_permission" id="market_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Market Permission -->

          <!-- Offers Permission (Write) -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Offers")} <span class="badge bg-light text-primary">{__("Write")}</span></div>
              <div class="form-text d-none d-sm-block">{__("Can Create Offers")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="offers_permission">
                <input type="checkbox" name="offers_permission" id="offers_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Offers Permission (Write) -->

          <!-- Offers Permission (Read) -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Offers")} <span class="badge bg-light text-primary">{__("Read")}</span></div>
              <div class="form-text d-none d-sm-block">{__("Can Read Offers")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="offers_permission_read">
                <input type="checkbox" name="offers_permission_read" id="offers_permission_read">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Offers Permission (Read) -->

          <!-- Jobs Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="jobs" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Jobs")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Create Jobs")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="jobs_permission">
                <input type="checkbox" name="jobs_permission" id="jobs_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Jobs Permission -->

          <!-- Courses Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="courses" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Courses")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Create courses")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="courses_permission">
                <input type="checkbox" name="courses_permission" id="courses_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Courses Permission -->

          <!-- Forums Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="forums" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Forums")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Threads/Replies")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="forums_permission">
                <input type="checkbox" name="forums_permission" id="forums_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Forums Permission -->

          <!-- Movies Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="movies" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Movies")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Watch Movies")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="movies_permission">
                <input type="checkbox" name="movies_permission" id="movies_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Movies Permission -->

          <!-- Games Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="games" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Games")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Play Games")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="games_permission">
                <input type="checkbox" name="games_permission" id="games_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Games Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Features Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Gifts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="gifts" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Gifts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Send Gifts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="gifts_permission">
                <input type="checkbox" name="gifts_permission" id="gifts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Gifts Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Stories Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Stories Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="24_hours" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Stories")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Stories")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="stories_permission">
                <input type="checkbox" name="stories_permission" id="stories_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Stories Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Posts Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Publish Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="posts_permission">
                <input type="checkbox" name="posts_permission" id="posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Posts Permission -->

          <!-- Posts Schedule Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="schedule" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Schedule Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Schedule Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="schedule_posts_permission">
                <input type="checkbox" name="schedule_posts_permission" id="schedule_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Posts Schedule Permission -->

          <!-- Colored Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="posts_colored" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Colored Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Colored Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="colored_posts_permission">
                <input type="checkbox" name="colored_posts_permission" id="colored_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Colored Posts Permission -->

          <!-- Feelings/Activity Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="smile" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Feelings/Activity Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Feelings/Activity Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="activity_posts_permission">
                <input type="checkbox" name="activity_posts_permission" id="activity_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Feelings/Activity Posts Permission -->

          <!-- Polls Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="polls" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Polls Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Polls Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="polls_posts_permission">
                <input type="checkbox" name="polls_posts_permission" id="polls_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Polls Posts Permission -->

          <!-- Geolocation Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Geolocation Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Geolocation Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="geolocation_posts_permission">
                <input type="checkbox" name="geolocation_posts_permission" id="geolocation_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Geolocation Posts Permission -->

          <!-- GIF Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="gif" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("GIF Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add GIF Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="gif_posts_permission">
                <input type="checkbox" name="gif_posts_permission" id="gif_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- GIF Posts Permission -->

          <!-- Anonymous Posts Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Anonymous Posts")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Add Anonymous Posts")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="anonymous_posts_permission">
                <input type="checkbox" name="anonymous_posts_permission" id="anonymous_posts_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Anonymous Posts Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Registration Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Invitation Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="invitation" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Invitation")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Generate Invitation Codes")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="invitation_permission">
                <input type="checkbox" name="invitation_permission" id="invitation_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Invitation Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Chat Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Audio Call Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="call_audio" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Audio Call")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Make Audio Calls")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="audio_call_permission">
                <input type="checkbox" name="audio_call_permission" id="audio_call_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Audio Call Permission -->

          <!-- Video Call Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="call_video" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Video Call")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Make Video Calls")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="video_call_permission">
                <input type="checkbox" name="video_call_permission" id="video_call_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Video Call Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Live Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Live Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="live" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Live")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Go Live")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="live_permission">
                <input type="checkbox" name="live_permission" id="live_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Live Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Uploads Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Videos Upload Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="videos" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Videos Upload")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Upload Videos")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="videos_upload_permission">
                <input type="checkbox" name="videos_upload_permission" id="videos_upload_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Videos Upload Permission -->

          <!-- Audios Upload Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="audios" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Audio Upload")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Upload Audio")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="audios_upload_permission">
                <input type="checkbox" name="audios_upload_permission" id="audios_upload_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Audios Upload Permission -->

          <!-- Files Upload Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="files" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Files Upload")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Upload Files")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="files_upload_permission">
                <input type="checkbox" name="files_upload_permission" id="files_upload_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Files Upload Permission -->
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Money Permissions")}
        </div>
        <div class="pl-md-4">
          <!-- Ads Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="ads" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Ads")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Create Ads")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="ads_permission">
                <input type="checkbox" name="ads_permission" id="ads_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Ads Permission -->

          <!-- Funding Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="funding" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Funding")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Raise Funding")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="funding_permission">
                <input type="checkbox" name="funding_permission" id="funding_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Funding Permission -->

          <!-- Monetization Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="monetization" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Monetization")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Monetize Content")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="monetization_permission">
                <input type="checkbox" name="monetization_permission" id="monetization_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Monetization Permission -->

          <!-- Tips Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="tips" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Tips")}</div>
              <div class="form-text d-none d-sm-block">{__("Can Receive Tips")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="tips_permission">
                <input type="checkbox" name="tips_permission" id="tips_permission">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
          <!-- Tips Permission -->

          <div class="divider"></div>

          <!-- Affiliates Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="affiliates" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Custom Affiliates System")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable it to override the default affiliates system")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="custom_affiliates_system">
                <input type="checkbox" name="custom_affiliates_system" id="custom_affiliates_system" {if $data['custom_affiliates_system']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          {include file='_affiliates_levels.tpl' _affiliate=$system}
          <!-- Affiliates Permission -->

          <div class="divider"></div>

          <!-- Points Permission -->
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="points" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Custom Points System")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable it to override the default points system")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="custom_points_system">
                <input type="checkbox" name="custom_points_system" id="custom_points_system">
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Points")}/{print_money("1.00")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="points_per_currency" value="{$system['points_per_currency']}">
              <div class="form-text">
                {__("How much points eqaul to")} {print_money("1")}
              </div>
            </div>
          </div>
          <!-- Points Permission -->
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

  {elseif $sub_view == "edit"}

    {if $data['edit_mods']}
      <form class="js_ajax-forms" data-url="admin/permissions_groups.php?do=edit_mods">
        <div class="card-body">
          <div class="heading-small mb20">
            {__("Group Info")}
          </div>
          <div class="pl-md-4">
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Group Title")}
              </label>
              <div class="col-md-9">
                <input class="form-control" name="title" value="{$data['permissions_group_title']}" readonly>
              </div>
            </div>
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Users Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Users Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Users")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Users")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_users_permission">
                  <input type="checkbox" name="mods_users_permission" id="mods_users_permission" {if $system['mods_users_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Users Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Modules Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_posts_permission">
                  <input type="checkbox" name="mods_posts_permission" id="mods_posts_permission" {if $system['mods_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Posts Permission -->

            <!-- Pages Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Pages")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Pages")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_pages_permission">
                  <input type="checkbox" name="mods_pages_permission" id="mods_pages_permission" {if $system['mods_pages_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Pages Permission -->

            <!-- Groups Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Groups")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Groups")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_groups_permission">
                  <input type="checkbox" name="mods_groups_permission" id="mods_groups_permission" {if $system['mods_groups_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Groups Permission -->

            <!-- Events Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="events" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Events")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Events")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_events_permission">
                  <input type="checkbox" name="mods_events_permission" id="mods_events_permission" {if $system['mods_events_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Events Permission -->

            <!-- Blogs Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Blogs")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Blogs")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_blogs_permission">
                  <input type="checkbox" name="mods_blogs_permission" id="mods_blogs_permission" {if $system['mods_blogs_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Blogs Permission -->

            <!-- Offers Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Offers")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Offers")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_offers_permission">
                  <input type="checkbox" name="mods_offers_permission" id="mods_offers_permission" {if $system['mods_offers_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Offers Permission -->

            <!-- Jobs Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="jobs" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Jobs")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Jobs")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_jobs_permission">
                  <input type="checkbox" name="mods_jobs_permission" id="mods_jobs_permission" {if $system['mods_jobs_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Jobs Permission -->

            <!-- Courses Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="courses" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Courses")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Courses")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_courses_permission">
                  <input type="checkbox" name="mods_courses_permission" id="mods_courses_permission" {if $system['mods_courses_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Courses Permission -->

            <!-- Forums Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="forums" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Forums")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Forums")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_forums_permission">
                  <input type="checkbox" name="mods_forums_permission" id="mods_forums_permission" {if $system['mods_forums_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Forums Permission -->

            <!-- Movies Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="movies" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Movies")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Movies")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_movies_permission">
                  <input type="checkbox" name="mods_movies_permission" id="mods_movies_permission" {if $system['mods_movies_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Movies Permission -->

            <!-- Games Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="games" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Games")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Games")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_games_permission">
                  <input type="checkbox" name="mods_games_permission" id="mods_games_permission" {if $system['mods_games_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Games Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Money Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Ads Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="ads" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Ads System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Ads System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_ads_permission">
                  <input type="checkbox" name="mods_ads_permission" id="mods_ads_permission" {if $system['mods_ads_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Ads Permission -->

            <!-- Wallet Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="wallet" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Wallet")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Wallet Section")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_wallet_permission">
                  <input type="checkbox" name="mods_wallet_permission" id="mods_wallet_permission" {if $system['mods_wallet_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Wallet Permission -->

            <!-- Pro Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="pro" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Pro System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Pro System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_pro_permission">
                  <input type="checkbox" name="mods_pro_permission" id="mods_pro_permission" {if $system['mods_pro_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Pro Permission -->

            <!-- Affiliates Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="affiliates" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Affiliates System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Affiliates System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_affiliates_permission">
                  <input type="checkbox" name="mods_affiliates_permission" id="mods_affiliates_permission" {if $system['mods_affiliates_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Affiliates Permission -->

            <!-- Points Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="points" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Points System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Points System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_points_permission">
                  <input type="checkbox" name="mods_points_permission" id="mods_points_permission" {if $system['mods_points_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Points Permission -->

            <!-- Marketplace Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="market" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Marketplace System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Marketplace System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_marketplace_permission">
                  <input type="checkbox" name="mods_marketplace_permission" id="mods_marketplace_permission" {if $system['mods_marketplace_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Marketplace Permission -->

            <!-- Funding Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="funding" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Funding System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Funding System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_funding_permission">
                  <input type="checkbox" name="mods_funding_permission" id="mods_funding_permission" {if $system['mods_funding_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Funding Permission -->

            <!-- Monetization Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="monetization" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Monetization System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Monetization System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_monetization_permission">
                  <input type="checkbox" name="mods_monetization_permission" id="mods_monetization_permission" {if $system['mods_monetization_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Monetization Permission -->

            <!-- Tips Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="tips" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Tips System")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Tips System")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_tips_permission">
                  <input type="checkbox" name="mods_tips_permission" id="mods_tips_permission" {if $system['mods_tips_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Tips Permission -->

          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Payments Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Payments Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="payments" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Payments")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Payments Section")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_payments_permission">
                  <input type="checkbox" name="mods_payments_permission" id="mods_payments_permission" {if $system['mods_payments_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Payments Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Developers Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Developers Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="developers" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Developers Options")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Developers Options")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_developers_permission">
                  <input type="checkbox" name="mods_developers_permission" id="mods_developers_permission" {if $system['mods_developers_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Developers Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Tools Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Reports Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="report" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Reports")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Reports")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_reports_permission">
                  <input type="checkbox" name="mods_reports_permission" id="mods_reports_permission" {if $system['mods_reports_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Reports Permission -->

            <!-- Blacklist Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="block" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Blacklist")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Blacklist")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_blacklist_permission">
                  <input type="checkbox" name="mods_blacklist_permission" id="mods_blacklist_permission" {if $system['mods_blacklist_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Blacklist Permission -->

            <!-- Verifications Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Verifications")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Verifications")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_verifications_permission">
                  <input type="checkbox" name="mods_verifications_permission" id="mods_verifications_permission" {if $system['mods_verifications_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Verifications Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Customization Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Customization Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="design" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Customization")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Customization Section")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_customization_permission">
                  <input type="checkbox" name="mods_customization_permission" id="mods_customization_permission" {if $system['mods_customization_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Customization Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Reach Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Reach Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="newsletter" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Reach")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Manage Reach Section")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="mods_reach_permission">
                  <input type="checkbox" name="mods_reach_permission" id="mods_reach_permission" {if $system['mods_reach_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Reach Permission -->
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
    {else}
      <form class="js_ajax-forms" data-url="admin/permissions_groups.php?do=edit&id={$data['permissions_group_id']}">
        <div class="card-body">
          <div class="heading-small mb20">
            {__("Group Info")}
          </div>
          <div class="pl-md-4">
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Group Title")}
              </label>
              <div class="col-md-9">
                <input class="form-control" name="title" value="{$data['permissions_group_title']}" {if in_array($data['permissions_group_id'], ['1', '2'])}readonly{/if}>
              </div>
            </div>
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Modules Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Pages Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Pages")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Create Pages")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="pages_permission">
                  <input type="checkbox" name="pages_permission" id="pages_permission" {if $data['pages_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Pages Permission -->

            <!-- Groups Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Groups")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Create Groups")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="groups_permission">
                  <input type="checkbox" name="groups_permission" id="groups_permission" {if $data['groups_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Groups Permission -->

            <!-- Events Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="events" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Events")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Create Events")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="events_permission">
                  <input type="checkbox" name="events_permission" id="events_permission" {if $data['events_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Events Permission -->

            <!-- Reels Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="reels" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Reels")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Reels")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="reels_permission">
                  <input type="checkbox" name="reels_permission" id="reels_permission" {if $data['reels_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Reels Permission -->

            <!-- Watch Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="watch" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Watch")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Watch Videos")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="watch_permission">
                  <input type="checkbox" name="watch_permission" id="watch_permission" {if $data['watch_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Watch Permission -->

            <!-- Blogs Permission (Write) -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Blogs")} <span class="badge bg-light text-primary">{__("Write")}</span></div>
                <div class="form-text d-none d-sm-block">{__("Can Write Blogs")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="blogs_permission">
                  <input type="checkbox" name="blogs_permission" id="blogs_permission" {if $data['blogs_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Blogs Permission (Write) -->

            <!-- Blogs Permission (Read) -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Blogs")} <span class="badge bg-light text-primary">{__("Read")}</span></div>
                <div class="form-text d-none d-sm-block">{__("Can Read Blogs")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="blogs_permission_read">
                  <input type="checkbox" name="blogs_permission_read" id="blogs_permission_read" {if $data['blogs_permission_read']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Blogs Permission (Read) -->

            <!-- Market Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="market" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Market")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Sell Products")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="market_permission">
                  <input type="checkbox" name="market_permission" id="market_permission" {if $data['market_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Market Permission -->

            <!-- Offers Permission (Write) -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Offers")} <span class="badge bg-light text-primary">{__("Write")}</span></div>
                <div class="form-text d-none d-sm-block">{__("Can Create Offers")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="offers_permission">
                  <input type="checkbox" name="offers_permission" id="offers_permission" {if $data['offers_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Offers Permission (Write) -->

            <!-- Offers Permission (Read) -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Offers")} <span class="badge bg-light text-primary">{__("Read")}</span></div>
                <div class="form-text d-none d-sm-block">{__("Can Read Offers")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="offers_permission_read">
                  <input type="checkbox" name="offers_permission_read" id="offers_permission_read" {if $data['offers_permission_read']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Offers Permission (Read) -->

            <!-- Jobs Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="jobs" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Jobs")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Create Jobs")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="jobs_permission">
                  <input type="checkbox" name="jobs_permission" id="jobs_permission" {if $data['jobs_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Jobs Permission -->

            <!-- Courses Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="courses" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Courses")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Create courses")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="courses_permission">
                  <input type="checkbox" name="courses_permission" id="courses_permission" {if $data['courses_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Courses Permission -->

            <!-- Forums Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="forums" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Forums")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Threads/Replies")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="forums_permission">
                  <input type="checkbox" name="forums_permission" id="forums_permission" {if $data['forums_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Forums Permission -->

            <!-- Movies Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="movies" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Movies")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Watch Movies")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="movies_permission">
                  <input type="checkbox" name="movies_permission" id="movies_permission" {if $data['movies_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Movies Permission -->

            <!-- Games Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="games" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Games")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Play Games")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="games_permission">
                  <input type="checkbox" name="games_permission" id="games_permission" {if $data['games_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Games Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Features Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Gifts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="gifts" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Gifts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Send Gifts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="gifts_permission">
                  <input type="checkbox" name="gifts_permission" id="gifts_permission" {if $data['gifts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Gifts Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Stories Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Stories Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="24_hours" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Stories")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Stories")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="stories_permission">
                  <input type="checkbox" name="stories_permission" id="stories_permission" {if $data['stories_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Stories Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Posts Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Publish Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="posts_permission">
                  <input type="checkbox" name="posts_permission" id="posts_permission" {if $data['posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Posts Permission -->

            <!-- Posts Schedule Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="schedule" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Schedule Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Schedule Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="schedule_posts_permission">
                  <input type="checkbox" name="schedule_posts_permission" id="schedule_posts_permission" {if $data['schedule_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Posts Schedule Permission -->

            <!-- Colored Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="posts_colored" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Colored Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Colored Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="colored_posts_permission">
                  <input type="checkbox" name="colored_posts_permission" id="colored_posts_permission" {if $data['colored_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Colored Posts Permission -->

            <!-- Feelings/Activity Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="smile" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Feelings/Activity Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Feelings/Activity Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="activity_posts_permission">
                  <input type="checkbox" name="activity_posts_permission" id="activity_posts_permission" {if $data['activity_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Feelings/Activity Posts Permission -->

            <!-- Polls Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="polls" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Polls Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Polls Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="polls_posts_permission">
                  <input type="checkbox" name="polls_posts_permission" id="polls_posts_permission" {if $data['polls_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Polls Posts Permission -->

            <!-- Geolocation Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Geolocation Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Geolocation Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="geolocation_posts_permission">
                  <input type="checkbox" name="geolocation_posts_permission" id="geolocation_posts_permission" {if $data['geolocation_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Geolocation Posts Permission -->

            <!-- GIF Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="gif" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("GIF Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add GIF Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="gif_posts_permission">
                  <input type="checkbox" name="gif_posts_permission" id="gif_posts_permission" {if $data['gif_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- GIF Posts Permission -->

            <!-- Anonymous Posts Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Anonymous Posts")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Add Anonymous Posts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="anonymous_posts_permission">
                  <input type="checkbox" name="anonymous_posts_permission" id="anonymous_posts_permission" {if $data['anonymous_posts_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Anonymous Posts Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Registration Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Invitation Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="invitation" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Invitation")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Generate Invitation Codes")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="invitation_permission">
                  <input type="checkbox" name="invitation_permission" id="invitation_permission" {if $data['invitation_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Invitation Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Chat Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Audio Call Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="call_audio" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Audio Call")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Make Audio Calls")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="audio_call_permission">
                  <input type="checkbox" name="audio_call_permission" id="audio_call_permission" {if $data['audio_call_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Audio Call Permission -->

            <!-- Video Call Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="call_video" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Video Call")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Make Video Calls")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="video_call_permission">
                  <input type="checkbox" name="video_call_permission" id="video_call_permission" {if $data['video_call_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Video Call Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Live Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Live Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="live" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Live")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Go Live")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="live_permission">
                  <input type="checkbox" name="live_permission" id="live_permission" {if $data['live_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Live Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Uploads Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Videos Upload Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="videos" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Videos Upload")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Upload Videos")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="videos_upload_permission">
                  <input type="checkbox" name="videos_upload_permission" id="videos_upload_permission" {if $data['videos_upload_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Videos Upload Permission -->

            <!-- Audios Upload Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="audios" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Audio Upload")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Upload Audio")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="audios_upload_permission">
                  <input type="checkbox" name="audios_upload_permission" id="audios_upload_permission" {if $data['audios_upload_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Audios Upload Permission -->

            <!-- Files Upload Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="files" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Files Upload")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Upload Files")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="files_upload_permission">
                  <input type="checkbox" name="files_upload_permission" id="files_upload_permission" {if $data['files_upload_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Files Upload Permission -->
          </div>

          <div class="divider"></div>

          <div class="heading-small mb20">
            {__("Money Permissions")}
          </div>
          <div class="pl-md-4">
            <!-- Ads Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="ads" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Ads")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Create Ads")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="ads_permission">
                  <input type="checkbox" name="ads_permission" id="ads_permission" {if $data['ads_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Ads Permission -->

            <!-- Funding Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="funding" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Funding")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Raise funding")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="funding_permission">
                  <input type="checkbox" name="funding_permission" id="funding_permission" {if $data['funding_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Funding Permission -->

            <!-- Monetization Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="monetization" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Monetization")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Monetize Content")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="monetization_permission">
                  <input type="checkbox" name="monetization_permission" id="monetization_permission" {if $data['monetization_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Monetization Permission -->

            <!-- Tips Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="tips" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Tips")}</div>
                <div class="form-text d-none d-sm-block">{__("Can Receive Tips")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="tips_permission">
                  <input type="checkbox" name="tips_permission" id="tips_permission" {if $data['tips_permission']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>
            <!-- Tips Permission -->

            <div class="divider"></div>

            <!-- Affiliates Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="affiliates" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Custom Affiliates System")}</div>
                <div class="form-text d-none d-sm-block">{__("Enable it to override the default affiliates system")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="custom_affiliates_system">
                  <input type="checkbox" name="custom_affiliates_system" id="custom_affiliates_system" {if $data['custom_affiliates_system']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            {include file='_affiliates_levels.tpl' _affiliate=$data}
            <!-- Affiliates Permission -->

            <div class="divider"></div>

            <!-- Points Permission -->
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="points" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Custom Points System")}</div>
                <div class="form-text d-none d-sm-block">{__("Enable it to override the default points system")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="custom_points_system">
                  <input type="checkbox" name="custom_points_system" id="custom_points_system" {if $data['custom_points_system']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Points")}/{print_money("1.00")}
              </label>
              <div class="col-md-9">
                <input type="text" class="form-control" name="points_per_currency" value="{$data['points_per_currency']}">
                <div class="form-text">
                  {__("How much points eqaul to")} {print_money("1")}
                </div>
              </div>
            </div>
            <!-- Points Permission -->
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
    {/if}

  {/if}
</div>