<div class="panel panel-default">
    <div class="panel-heading with-icon">
        {if $sub_view == "edit"}
            <div class="pull-right flip">
                <a target="_blank" href="{$system['system_url']}/{$data['user_name']}" class="btn btn-info">
                    <i class="fa fa-tv fa-fw mr5"></i>{__("View Profile")}
                </a>
            </div>
        {elseif $sub_view == "banned"}
            <div class="pull-right flip">
                <a href="{$system['system_url']}/admincp/banned_ips" class="btn btn-danger">
                    <i class="fa fa-user-times"></i> {__("Manage Banned IPs")}
                </a>
            </div>
        {/if}
        <i class="fa fa-user pr5 panel-icon"></i>
        <strong>{__("Users")}</strong>
        {if $sub_view != "" && $sub_view != "edit"} &rsaquo; <strong>{__($sub_view|capitalize)}</strong>{/if}
        {if $sub_view == "edit"} &rsaquo; <strong>{$data['user_firstname']} {$data['user_lastname']}</strong>{/if}
    </div>
    {if $sub_view == "" || $sub_view == "admins" || $sub_view == "moderators" || $sub_view == "online" || $sub_view == "banned"}
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover js_dataTable">
                    <thead>
                        <tr>
                            <th>{__("ID")}</th>
                            <th>{__("Name")}</th>
                            <th>{__("Username")}</th>
                            <th>{__("Joined")}</th>
                            <th>{__("Activated")}</th>
                            <th>{__("Actions")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $rows as $row}
                        <tr>
                            <td><a href="{$system['system_url']}/{$row['user_name']}" target="_blank">{$row['user_id']}</a></td>
                            <td>
                                <a target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                                    <img class="tbl-image" src="{$row['user_picture']}">
                                    {$row['user_firstname']} {$row['user_lastname']}
                                </a>
                            </td>
                            <td>
                                <a href="{$system['system_url']}/{$row['user_name']}" target="_blank">
                                    {$row['user_name']}
                                </a>
                            </td>
                            <td>{$row['user_registered']|date_format:"%e %B %Y"}</td>
                            <td>
                                {if $row['user_activated']}
                                    <span class="label label-success">{__("Yes")}</span>
                                {else}
                                    <span class="label label-danger">{__("No")}</span>
                                {/if}
                            </td>
                            <td>
                                <button data-toggle="tooltip" data-placement="top" title='{__("Delete")}' class="btn btn-xs btn-danger js_admin-deleter" data-handle="user" data-id="{$row['user_id']}">
                                    <i class="fa fa-trash-alt"></i>
                                </button>
                                <a data-toggle="tooltip" data-placement="top" title='{__("Edit")}' href="{$system['system_url']}/admincp/users/edit/{$row['user_id']}" class="btn btn-xs btn-primary">
                                    <i class="fa fa-pencil-alt"></i>
                                </a>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    {elseif $sub_view == "edit"}
        <div class="panel-body">
            <div class="row">
                <div class="col-xs-offset-3 col-xs-6 col-sm-offset-0 col-sm-2 mb10">
                    <img class="img-responsive img-thumbnail" src="{$data['user_picture']}">
                </div>
                <div class="col-xs-12 col-sm-5 mb10">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <span class="badge">{$data['user_id']}</span>
                            {__("User ID")}
                        </li>
                        <li class="list-group-item">
                            <span class="badge">{$data['user_registered']|date_format:"%e %B %Y"}</span>
                            {__("Joined")}
                        </li>
                        <li class="list-group-item">
                            <span class="badge">{$data['user_last_seen']|date_format:"%e %B %Y"}</span>
                            {__("Last Login")}
                        </li>
                    </ul>
                </div>
                <div class="col-xs-12 col-sm-5 mb10">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <span class="badge">{$data['friends']}</span>
                            {__("Friends")}
                        </li>
                        <li class="list-group-item">
                            <span class="badge">{$data['followings']}</span>
                            {__("Followings")}
                        </li>
                        <li class="list-group-item">
                            <span class="badge">{$data['followers']}</span>
                            {__("Followers")}
                        </li>
                    </ul>
                </div>
            </div>

            <!-- tabs nav -->
            <ul class="nav nav-tabs mb20">
                <li class="active">
                    <a href="#account" data-toggle="tab">
                        <i class="fa fa-cog fa-fw mr5"></i><strong class="pr5">{__("Account")}</strong>
                    </a>
                </li>
                <li>
                    <a href="#profile" data-toggle="tab">
                        <i class="fa fa-user fa-fw mr5"></i><strong class="pr5">{__("Profile")}</strong>
                    </a>
                </li>
                <li>
                    <a href="#privacy" data-toggle="tab">
                        <i class="fa fa-lock fa-fw mr5"></i><strong class="pr5">{__("Privacy")}</strong>
                    </a>
                </li>
                <li>
                    <a href="#security" data-toggle="tab">
                        <i class="fa fa-shield-alt fa-fw mr5"></i><strong class="pr5">{__("Security")}</strong>
                    </a>
                </li>
                {if $system['packages_enabled']}
                    <li>
                        <a href="#membership" data-toggle="tab">
                            <i class="fa fa-id-card fa-fw mr5"></i><strong class="pr5">{__("Membership")}</strong>
                        </a>
                    </li>
                {/if}
                {if $system['ads_enabled']}
                    <li>
                        <a href="#wallet" data-toggle="tab">
                            <i class="fa fa-wallet fa-fw mr5"></i><strong class="pr5">{__("Wallet")}</strong>
                        </a>
                    </li>
                {/if}
            </ul>
            <!-- tabs nav -->

            <!-- tabs content -->
            <div class="tab-content">
                <!-- account tab -->
                <div class="tab-pane active" id="account">
                    <form class="js_ajax-forms form-horizontal" data-url="admin/users.php?id={$data['user_id']}&do=edit_account">
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Verified User")}
                            </label>
                            <div class="col-sm-9">
                                <label class="switch" for="user_verified">
                                    <input type="checkbox" name="user_verified" id="user_verified" {if $data['user_verified']}checked{/if}>
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Banned")}
                            </label>
                            <div class="col-sm-9">
                                <label class="switch" for="user_banned">
                                    <input type="checkbox" name="user_banned" id="user_banned" {if $data['user_banned']}checked{/if}>
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Email Activated")}
                            </label>
                            <div class="col-sm-9">
                                <label class="switch" for="user_activated">
                                    <input type="checkbox" name="user_activated" id="user_activated" {if $data['user_activated']}checked{/if}>
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("User Group")}
                            </label>
                            <div class="col-sm-9">
                                <select class="form-control" name="user_group">
                                    <option value="1" {if $data['user_group'] == '1'}selected{/if}>
                                        {__("Administrators")}
                                    </option>
                                    <option value="2" {if $data['user_group'] == '2'}selected{/if}>
                                        {__("Moderators")}
                                    </option>
                                    <option value="3" {if $data['user_group'] == '3'}selected{/if}>
                                        {__("Users")}
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Username")}
                            </label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <span class="input-group-addon">{$system['system_url']}/</span>
                                    <input type="text" class="form-control" name="user_name" value="{$data['user_name']}">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Email Address")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_email" value="{$data['user_email']}">
                            </div>
                        </div>

                        {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
                            <div class="form-group">
                                <label class="col-sm-3 control-label text-left">
                                    {__("Phone Number")}
                                </label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" name="user_phone" value="{$data['user_phone']}">
                                    <span class="help-block">
                                        {__("Phone number (eg. +905...)")}
                                    </span>
                                </div>
                            </div>
                        {/if}

                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Password")}
                            </label>
                            <div class="col-sm-9">
                                <input type="password" class="form-control" name="user_password">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-9 col-sm-offset-3">
                                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                            </div>
                        </div>

                        <!-- success -->
                        <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                        <!-- success -->

                        <!-- error -->
                        <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                        <!-- error -->
                    </form>
                </div>
                <!-- account tab -->

                <!-- profile tab -->
                <div class="tab-pane" id="profile">
                    <form class="js_ajax-forms form-horizontal" data-url="admin/users.php?id={$data['user_id']}&do=edit_profile">
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("First Name")}
                            </label>
                            <div class="col-sm-9">
                                <input class="form-control" name="user_firstname" value="{$data['user_firstname']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Last Name")}
                            </label>
                            <div class="col-sm-9">
                                <input class="form-control" name="user_lastname" value="{$data['user_lastname']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("I am")}
                            </label>
                            <div class="col-sm-9">
                                <select class="form-control" name="user_gender">
                                    <option value="none">{__("Select Sex")}:</option>
                                    <option {if $data['user_gender'] == "male"}selected{/if} value="male">{__("Male")}</option>
                                    <option {if $data['user_gender'] == "female"}selected{/if} value="female">{__("Female")}</option>
                                    <option {if $data['user_gender'] == "other"}selected{/if} value="other">{__("Other")}</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Country")}
                            </label>
                            <div class="col-sm-9">
                                <select class="form-control" name="user_country">
                                    <option value="none">{__("Select Country")}</option>
                                    {foreach $countries as $country}
                                        <option {if $data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name']}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Birthdate")}
                            </label>
                            <div class="col-sm-9">
                                <div class="row">
                                    <div class="col-xs-4">
                                        <select class="form-control" name="birth_month">
                                            <option value="none">{__("Select Month")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '1'}selected{/if} value="1">{__("Jan")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '2'}selected{/if} value="2">{__("Feb")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '3'}selected{/if} value="3">{__("Mar")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '4'}selected{/if} value="4">{__("Apr")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '5'}selected{/if} value="5">{__("May")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '6'}selected{/if} value="6">{__("Jun")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '7'}selected{/if} value="7">{__("Jul")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '8'}selected{/if} value="8">{__("Aug")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '9'}selected{/if} value="9">{__("Sep")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '10'}selected{/if} value="10">{__("Oct")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '11'}selected{/if} value="11">{__("Nov")}</option>
                                            <option {if $data['user_birthdate_parsed']['month'] == '12'}selected{/if} value="12">{__("Dec")}</option>
                                        </select>
                                    </div>
                                    <div class="col-xs-4">
                                        <select class="form-control" name="birth_day">
                                            <option value="none">{__("Select Day")}</option>
                                            {for $i=1 to 31}
                                            <option {if $data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
                                            {/for}
                                        </select>
                                    </div>
                                    <div class="col-xs-4">
                                        <select class="form-control" name="birth_year">
                                            <option value="none">{__("Select Year")}</option>
                                            {for $i=1905 to 2015}
                                            <option {if $data['user_birthdate_parsed']['year'] == $i}selected{/if} value="{$i}">{$i}</option>
                                            {/for}
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                {__("Relationship Status")}
                            </label>
                            <div class="col-sm-9">
                                <select name="user_relationship" class="form-control">
                                    <option value="none">{__("Select Relationship")}</option>
                                    <option {if $data['user_relationship'] == "single"}selected{/if} value="single">{__("Single")}</option>
                                    <option {if $data['user_relationship'] == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
                                    <option {if $data['user_relationship'] == "married"}selected{/if} value="married">{__("Married")}</option>
                                    <option {if $data['user_relationship'] == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
                                    <option {if $data['user_relationship'] == "separated"}selected{/if} value="separated">{__("Separated")}</option>
                                    <option {if $data['user_relationship'] == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
                                    <option {if $data['user_relationship'] == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                {__("About Me")}
                            </label>
                            <div class="col-sm-9">
                                <textarea class="form-control" name="user_biography">{$data['user_biography']}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                {__("Website")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_website" value="{$data['user_website']}">
                            </div>
                        </div>
                        <div class="divider"></div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Work Title")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_work_title" value="{$data['user_work_title']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Work Place")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_work_place" value="{$data['user_work_place']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Work Website")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_work_url" value="{$data['user_work_url']}">
                            </div>
                        </div>
                        <div class="divider"></div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Current City")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_current_city" value="{$data['user_current_city']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Hometown")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_hometown" value="{$data['user_hometown']}">
                            </div>
                        </div>
                        <div class="divider"></div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Major")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_edu_major" value="{$data['user_edu_major']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("School")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_edu_school" value="{$data['user_edu_school']}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Class")}
                            </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="user_edu_class" value="{$data['user_edu_class']}">
                            </div>
                        </div>
                        <div class="divider"></div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-facebook-square fa-2x" style="color: #3B579D"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="facebook" value="{$data['user_social_facebook']}" placeholder="{__("Facebook Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-twitter-square fa-2x" style="color: #55ACEE"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="twitter" value="{$data['user_social_twitter']}" placeholder="{__("Twitter Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-google-plus-square fa-2x" style="color: #DC4A38"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="google" value="{$data['user_social_google']}" placeholder="{__("Google+ Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-youtube fa-2x" style="color: #E62117"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="youtube" value="{$data['user_social_youtube']}" placeholder="{__("YouTube Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-instagram fa-2x" style="color: #3f729b"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="instagram" value="{$data['user_social_instagram']}" placeholder="{__("Instagram Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-linkedin fa-2x" style="color: #1A84BC"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="linkedin" value="{$data['user_social_linkedin']}" placeholder="{__("LinkedIn Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                <i class="fab fa-vk fa-2x" style="color: #527498"></i>
                            </label>
                            <div class="col-sm-9 mt5">
                                <input type="text" class="form-control" name="vkontakte" value="{$data['user_social_vkontakte']}" placeholder="{__("Vkontakte Profile URL")}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-9 col-sm-offset-3">
                                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                            </div>
                        </div>

                        <!-- success -->
                        <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                        <!-- success -->

                        <!-- error -->
                        <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                        <!-- error -->
                    </form>
                </div>
                <!-- profile tab -->

                <!-- privacy tab -->
                <div class="tab-pane" id="privacy">
                    <form class="js_ajax-forms form-horizontal" data-url="admin/users.php?id={$data['user_id']}&do=edit_privacy">
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_chat">
                                {__("Chat")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_chat" id="privacy_chat">
                                    <option {if $data['user_chat_enabled'] == 0}selected{/if} value="0">
                                        {__("Offline")}
                                    </option>
                                    <option {if $data['user_chat_enabled'] == 1}selected{/if} value="1">
                                        {__("Online")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_wall">
                                {__("Who can post on your wall")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_wall" id="privacy_wall">
                                    <option {if $data['user_privacy_wall'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_wall'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_wall'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_birthdate">
                                {__("Who can see your")} {__("birthdate")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_birthdate" id="privacy_birthdate">
                                    <option {if $data['user_privacy_birthdate'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_birthdate'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_birthdate'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_relationship">
                                {__("Who can see your")} {__("relationship")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_relationship" id="privacy_relationship">
                                    <option {if $data['user_privacy_relationship'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_relationship'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_relationship'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_basic">
                                {__("Who can see your")} {__("basic info")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_basic" id="privacy_basic">
                                    <option {if $data['user_privacy_basic'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_basic'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_basic'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_work">
                                {__("Who can see your")} {__("work info")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_work" id="privacy_work">
                                    <option {if $data['user_privacy_work'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_work'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_work'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_location">
                                {__("Who can see your")} {__("location info")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_location" id="privacy_location">
                                    <option {if $data['user_privacy_location'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_location'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_location'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_education">
                                {__("Who can see your")} {__("education info")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_education" id="privacy_education">
                                    <option {if $data['user_privacy_education'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_education'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_education'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_other">
                                {__("Who can see your")} {__("other info")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_other" id="privacy_other">
                                    <option {if $data['user_privacy_other'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_other'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_other'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_friends">
                                {__("Who can see your")} {__("friends")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_friends" id="privacy_friends">
                                    <option {if $data['user_privacy_friends'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_friends'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_friends'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_photos">
                                {__("Who can see your")} {__("photos")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_photos" id="privacy_photos">
                                    <option {if $data['user_privacy_photos'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_photos'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_photos'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_pages">
                                {__("Who can see your")} {__("liked pages")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_pages" id="privacy_pages">
                                    <option {if $data['user_privacy_pages'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_pages'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_pages'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_groups">
                                {__("Who can see your")} {__("joined groups")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_groups" id="privacy_groups">
                                    <option {if $data['user_privacy_groups'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_groups'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_groups'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-5 control-label" for="privacy_events">
                                {__("Who can see your")} {__("joined events")}
                            </label>
                            <div class="col-sm-3">
                                <select class="form-control" name="privacy_events" id="privacy_events">
                                    <option {if $data['user_privacy_events'] == "public"}selected{/if} value="public">
                                        {__("Everyone")}
                                    </option>
                                    <option {if $data['user_privacy_events'] == "friends"}selected{/if} value="friends">
                                        {__("Friends")}
                                    </option>
                                    <option {if $data['user_privacy_events'] == "me"}selected{/if} value="me">
                                        {__("Just Me")}
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-7 col-sm-offset-5">
                                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                            </div>
                        </div>

                        <!-- success -->
                        <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                        <!-- success -->

                        <!-- error -->
                        <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                        <!-- error -->
                    </form>
                </div>
                <!-- privacy tab -->

                <!-- security tab -->
                <div class="tab-pane" id="security">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-hover js_dataTable">
                            <thead>
                                <tr>
                                    <th>{__("ID")}</th>
                                    <th>{__("Browser")}</th>
                                    <th>{__("OS")}</th>
                                    <th>{__("Date")}</th>
                                    <th>{__("IP")}</th>
                                    <th>{__("Actions")}</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $data['sessions'] as $session}
                                    <tr>
                                        <td>{$session@iteration}</td>
                                        <td>{$session['user_browser']}</td>
                                        <td>{$session['user_os']}</td>
                                        <td>
                                            <span class="js_moment" data-time="{$session['session_date']}">{$session['session_date']}</span>
                                        </td>
                                        <td>{$session['user_ip']}</td>
                                        <td>
                                            <button data-toggle="tooltip" data-placement="top" title='{__("End Session")}' class="btn btn-xs btn-danger js_admin-deleter" data-handle="session" data-id="{$session['session_id']}">
                                                <i class="fa fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- security tab -->

                <!-- membership tab -->
                <div class="tab-pane" id="membership">
                    <form class="js_ajax-forms form-horizontal" data-url="admin/users.php?id={$data['user_id']}&do=edit_membership">
                        
                        {if $data['user_subscribed']}
                            <div class="form-group mb0">
                                <label class="col-sm-3 control-label text-left">
                                    {__("Package")}
                                </label>
                                <div class="col-sm-9">
                                    <p class="form-control-static">
                                        {$data['name']} ({$system['system_currency_symbol']}{$data['price']} 
                                        {if $data['period'] == "life"}{__("Life Time")}{else}{__("per")} {if $data['period_num'] != '1'}{$data['period_num']}{/if} {__($data['period']|ucfirst)}{/if})
                                    </p>
                                </div>
                            </div>
                            <div class="form-group mb0">
                                <label class="col-sm-3 control-label text-left">
                                    {__("Subscription Date")}
                                </label>
                                <div class="col-sm-9">
                                    <p class="form-control-static">
                                        {$data['user_subscription_date']|date_format:"%e %B %Y"}
                                    </p>
                                </div>
                            </div>
                            <div class="form-group mb0">
                                <label class="col-sm-3 control-label text-left">
                                    {__("Expiration Date")}
                                </label>
                                <div class="col-sm-9">
                                    <p class="form-control-static">
                                        {if $data['period'] == "life"}
                                            {__("Life Time")}
                                        {else}
                                            {$data['subscription_end']|date_format:"%e %B %Y"} ({if $data['subscription_timeleft'] > 0}{__("Remining")} {$data['subscription_timeleft']} {__("Days")}{else}{__("Expired")}{/if})
                                        {/if}
                                    </p>
                                </div>
                            </div>
                            <div class="form-group mb0">
                                <label class="col-sm-3 control-label text-left">
                                    {__("Boosted Posts")}
                                </label>
                                <div class="col-sm-9">
                                    <p class="form-control-static">
                                        {$data['user_boosted_posts']}/{$data['boost_posts']}
                                    </p>
                                    
                                    <div class="progress mb5">
                                        <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" aria-valuenow="{($data['user_boosted_posts']/$data['boost_pages'])*100}" aria-valuemin="0" aria-valuemax="100" style="width: {($data['user_boosted_posts']/$data['boost_pages'])*100}%"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label text-left">
                                    {__("Boosted Pages")}
                                </label>
                                <div class="col-sm-9">
                                    <p class="form-control-static">
                                        {$data['user_boosted_pages']}/{$data['boost_pages']}
                                    </p>
                                    
                                    <div class="progress mb5">
                                        <div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar" aria-valuenow="{($data['user_boosted_pages']/$data['boost_pages'])*100}" aria-valuemin="0" aria-valuemax="100" style="width: {($data['user_boosted_pages']/$data['boost_pages'])*100}%"></div>
                                    </div>
                                </div>
                            </div>
                        {/if}
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Upgrade Package")}
                            </label>
                            <div class="col-sm-9">
                                <select class="form-control" name="package">
                                    {foreach $packages as $package}
                                        <option value="{$package['package_id']}" {if $data['user_package'] == $package['package_id']}selected{/if}>
                                            {$package['name']} ({$system['system_currency_symbol']}{$package['price']} 
                                            {if $package['period'] == "life"}{__("Life Time")}{else}{__("per")} {if $package['period_num'] != '1'}{$package['period_num']}{/if} {__($package['period']|ucfirst)}{/if})
                                        </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-9 col-sm-offset-3">
                                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                                {if $data['user_subscribed']}
                                    <button type="button" class="btn btn-danger js_admin-deleter" data-handle="user_package" data-id="{$data['user_id']}">
                                        <i class="fa fa-trash-alt"></i> {__("Remove Package")}
                                    </button>
                                {/if}
                            </div>
                        </div>

                        <!-- success -->
                        <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                        <!-- success -->

                        <!-- error -->
                        <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                        <!-- error -->
                    </form>
                </div>
                <!-- membership tab -->

                <!-- wallet tab -->
                <div class="tab-pane" id="wallet">
                    <form class="js_ajax-forms form-horizontal" data-url="admin/users.php?id={$data['user_id']}&do=edit_wallet">
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label text-left">
                                {__("Wallet Balance")}
                            </label>
                            <div class="col-sm-9">
                                <div class="input-money">
                                    <span>{$system['system_currency_symbol']}</span>
                                    <input type="text" class="form-control" placeholder="0.00" min="1.00" max="1000" name="user_wallet_balance" value="{$data['user_wallet_balance']}">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-9 col-sm-offset-3">
                                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                            </div>
                        </div>

                        <!-- success -->
                        <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                        <!-- success -->

                        <!-- error -->
                        <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                        <!-- error -->
                    </form>
                </div>
                <!-- wallet tab -->
            </div>
            <!-- tabs content -->
        </div>
    {/if}
</div>