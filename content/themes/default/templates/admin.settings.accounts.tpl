<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Accounts")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#General" data-bs-toggle="tab">
        <i class="fa fa-user-cog fa-fw mr5"></i><strong>{__("General")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Profile" data-bs-toggle="tab">
        <i class="fa fa-address-card fa-fw mr5"></i><strong>{__("Profile")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Privacy" data-bs-toggle="tab">
        <i class="fa fa-lock fa-fw mr5"></i><strong>{__("Privacy")}</strong>
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
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=accounts">
      <div class="card-body">

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="registration" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Friends System")}</div>
            <div class="form-text d-none d-sm-block">{__("if disabled only following system will be available")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="friends_enabled">
              <input type="checkbox" name="friends_enabled" id="friends_enabled" {if $system['friends_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="followings" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Disable Friend Request After Decline")}</div>
            <div class="form-text d-none d-sm-block">{__("If enabled user A will be able to send friendship request to user B again")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="disable_declined_friendrequest">
              <input type="checkbox" name="disable_declined_friendrequest" id="disable_declined_friendrequest" {if $system['disable_declined_friendrequest']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max Friends/User")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_friends" value="{$system['max_friends']}">
            <div class="form-text">
              {__("The Maximum number of friends allowed per User (0 for unlimited)")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="accounts_switcher" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Switch Accounts")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to switch between multiple accounts")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="switch_accounts_enabled">
              <input type="checkbox" name="switch_accounts_enabled" id="switch_accounts_enabled" {if $system['switch_accounts_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="genders" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Disable Genders")}</div>
            <div class="form-text d-none d-sm-block">{__("If disabled genders will be hidden for the users")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="genders_disabled">
              <input type="checkbox" name="genders_disabled" id="genders_disabled" {if $system['genders_disabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="username" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Show Usernames Only")}</div>
            <div class="form-text d-none d-sm-block">{__("If disabled full names will be displayed instead")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="show_usernames_enabled">
              <input type="checkbox" name="show_usernames_enabled" id="show_usernames_enabled" {if $system['show_usernames_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="username" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Disable Username Changes")}</div>
            <div class="form-text d-none d-sm-block">{__("If enabled users will not be able to change their usernames")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="disable_username_changes">
              <input type="checkbox" name="disable_username_changes" id="disable_username_changes" {if $system['disable_username_changes']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="special_characters" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Allow Special Characters")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow special Characters in user's first & last name")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="special_characters_enabled">
              <input type="checkbox" name="special_characters_enabled" id="special_characters_enabled" {if $system['special_characters_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="delete_user" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Delete Account")} ({__("GDPR")})</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to delete their account")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="delete_accounts_enabled">
              <input type="checkbox" name="delete_accounts_enabled" id="delete_accounts_enabled" {if $system['delete_accounts_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="user_information" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Download User Information")} ({__("GDPR")})</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to download their account information from settings page")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="download_info_enabled">
              <input type="checkbox" name="download_info_enabled" id="download_info_enabled" {if $system['download_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Verification Requests")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the verification requests from users & pages On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="verification_requests">
              <input type="checkbox" name="verification_requests" id="verification_requests" {if $system['verification_requests']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Verification Documents")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable it to make verification documents required")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="verification_docs_required">
              <input type="checkbox" name="verification_docs_required" id="verification_docs_required" {if $system['verification_docs_required']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Required for Posts")}</div>
            <div class="form-text d-none d-sm-block">{__("If enabled then verification will be required to publish posts")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="verification_for_posts">
              <input type="checkbox" name="verification_for_posts" id="verification_for_posts" {if $system['verification_for_posts']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Required for Monetization")}</div>
            <div class="form-text d-none d-sm-block">{__("If enabled then verification will be required to enable monetization")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="verification_for_monetization">
              <input type="checkbox" name="verification_for_monetization" id="verification_for_monetization" {if $system['verification_for_monetization']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Required for Adult Content")}</div>
            <div class="form-text d-none d-sm-block">{__("If enabled then verification will be required to share or consume adult content")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="verification_for_adult_content">
              <input type="checkbox" name="verification_for_adult_content" id="verification_for_adult_content" {if $system['verification_for_adult_content']}checked{/if}>
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
  <!-- General -->

  <!-- Profile -->
  <div class="tab-pane" id="Profile">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=profile">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="relationship" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Relationship Status")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Relationship Status On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="relationship_info_enabled">
              <input type="checkbox" name="relationship_info_enabled" id="relationship_info_enabled" {if $system['relationship_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="website" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Website")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Website On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="website_info_enabled">
              <input type="checkbox" name="website_info_enabled" id="website_info_enabled" {if $system['website_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="biography" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("About Me")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the About Me On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="biography_info_enabled">
              <input type="checkbox" name="biography_info_enabled" id="biography_info_enabled" {if $system['biography_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="jobs" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Work Info")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Work info On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="work_info_enabled">
              <input type="checkbox" name="work_info_enabled" id="work_info_enabled" {if $system['work_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Location Info")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Location info On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="location_info_enabled">
              <input type="checkbox" name="location_info_enabled" id="location_info_enabled" {if $system['location_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="education" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Education Info")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Education info On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="education_info_enabled">
              <input type="checkbox" name="education_info_enabled" id="education_info_enabled" {if $system['education_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="social_share" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Social Links")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Social Links On/Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="social_info_enabled">
              <input type="checkbox" name="social_info_enabled" id="social_info_enabled" {if $system['social_info_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="design" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Profile Design")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Allow users to upload background image to their profiles")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="system_profile_background_enabled">
              <input type="checkbox" name="system_profile_background_enabled" id="system_profile_background_enabled" {if $system['system_profile_background_enabled']}checked{/if}>
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
  <!-- Profile -->

  <!-- Privacy -->
  <div class="tab-pane" id="Privacy">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=privacy">
      <div class="card-body">
        <div class="alert alert-info">
          <div class="icon">
            <i class="fa fa-info-circle fa-2x"></i>
          </div>
          <div class="text pt5">
            {__("Set the default privacy settings for your new users")}
          </div>
        </div>
        <div class="row">
          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can message you?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-message"></i></span>
              <select class="form-select" name="user_privacy_chat">
                <option {if $system['user_privacy_chat'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_chat'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_chat'] == "me"}selected{/if} value="me">
                  {__("No One")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can poke you?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-hand-point-right"></i></span>
              <select class="form-select" name="user_privacy_poke">
                <option {if $system['user_privacy_poke'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_poke'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_poke'] == "me"}selected{/if} value="me">
                  {__("No One")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can send you gifts?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-gift"></i></span>
              <select class="form-select" name="user_privacy_gifts">
                <option {if $system['user_privacy_gifts'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_gifts'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_gifts'] == "me"}selected{/if} value="me">
                  {__("No One")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can post on your wall?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-newspaper"></i></span>
              <select class="form-select" name="user_privacy_wall">
                <option {if $system['user_privacy_wall'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_wall'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_wall'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can tag you in collaborative posts?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
              <select class="form-select" name="user_privacy_collaborative">
                <option {if $system['user_privacy_collaborative'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_collaborative'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_collaborative'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your gender?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-venus-mars"></i></span>
              <select class="form-select" name="user_privacy_gender">
                <option {if $system['user_privacy_gender'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_gender'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_gender'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your relationship?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-heart"></i></span>
              <select class="form-select" name="user_privacy_relationship">
                <option {if $system['user_privacy_relationship'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_relationship'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_relationship'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your birthdate?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-birthday-cake"></i></span>
              <select class="form-select" name="user_privacy_birthdate">
                <option {if $system['user_privacy_birthdate'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_birthdate'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_birthdate'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your basic info?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-user"></i></span>
              <select class="form-select" name="user_privacy_basic">
                <option {if $system['user_privacy_basic'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_basic'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_basic'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your work info?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-briefcase"></i></span>
              <select class="form-select" name="user_privacy_work">
                <option {if $system['user_privacy_work'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_work'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_work'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your location info?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
              <select class="form-select" name="user_privacy_location">
                <option {if $system['user_privacy_location'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_location'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_location'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your education info?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-university"></i></span>
              <select class="form-select" name="user_privacy_education">
                <option {if $system['user_privacy_education'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_education'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_education'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your other info?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-folder-plus"></i></span>
              <select class="form-select" name="user_privacy_other">
                <option {if $system['user_privacy_other'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_other'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_other'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your friends?")} {if !$system['friends_enabled']}<span class="badge bg-light text-primary">{__("Disabled")}{/if}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-user-friends"></i></span>
              <select class="form-select" name="user_privacy_friends">
                <option {if $system['user_privacy_friends'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_friends'] == "friends"}selected{/if} value="friends">
                  {__("Friends")}
                </option>
                <option {if $system['user_privacy_friends'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your followers/followings?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-user-friends"></i></span>
              <select class="form-select" name="user_privacy_followers">
                <option {if $system['user_privacy_followers'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_followers'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_followers'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your subscriptions?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-user-friends"></i></span>
              <select class="form-select" name="user_privacy_subscriptions">
                <option {if $system['user_privacy_subscriptions'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_subscriptions'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_subscriptions'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your photos?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-images"></i></span>
              <select class="form-select" name="user_privacy_photos">
                <option {if $system['user_privacy_photos'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_photos'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_photos'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your liked pages?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-flag"></i></span>
              <select class="form-select" name="user_privacy_pages">
                <option {if $system['user_privacy_pages'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_pages'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_pages'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your joined groups?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-users"></i></span>
              <select class="form-select" name="user_privacy_groups">
                <option {if $system['user_privacy_groups'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_groups'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_groups'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-6">
            <label class="form-label">{__("Who can see your joined events?")}</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-calendar"></i></span>
              <select class="form-select" name="user_privacy_events">
                <option {if $system['user_privacy_events'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $system['user_privacy_events'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $system['user_privacy_events'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
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
  <!-- Privacy -->
</div>
<!-- tab-content -->