{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="container {if $user->_logged_in}offcanvas{/if}">
    <div class="row">

        <!-- left panel -->
        {if $user->_logged_in}
            <div class="hidden-sm col-md-2 offcanvas-sidebar mt20">
                {include file='_sidebar.tpl'}
            </div>
        {/if}
        <!-- left panel -->

        <!-- right panel -->
        <div class="col-xs-12 {if $user->_logged_in}col-md-10 offcanvas-mainbar{/if}">

            <!-- profile-header -->
            <div class="profile-header no-avatar">
                <!-- profile-cover -->
                <div {if $event['event_cover_id']} class="profile-cover-wrapper js_lightbox" data-id="{$event['event_cover_id']}" data-image="{$system['system_uploads']}/{$event['event_cover']}" data-context="album" {else} class="profile-cover-wrapper" {/if}  {if $event['event_cover']} style="background-image:url('{$system['system_uploads']}/{$event['event_cover']}');" {/if}>
                    {if $user->_data['user_id'] == $event['event_admin']}
                        <div class="profile-cover-change">
                            <i class="fa fa-camera js_x-uploader" data-handle="cover-event" data-id="{$event['event_id']}"></i>
                        </div>
                        <div class="profile-cover-delete {if !$event['event_cover']}x-hidden{/if}">
                            <i class="fa fa-trash js_delete-cover" data-handle="cover-event" data-id="{$event['event_id']}" title='{__("Delete Cover")}'></i>
                        </div>
                        <div class="profile-cover-change-loader">
                            <div class="loader loader_large"></div>
                        </div>
                    {/if}
                </div>
                <!-- profile-cover -->

                <!-- profile-name -->
                <div class="profle-date-wrapper">
                    {$event['event_start_date']|date_format:"%b"}<br>{$event['event_start_date']|date_format:"%e"}
                </div>
                <div class="profile-name-wrapper">
                    <a href="{$system['system_url']}/events/{$event['event_id']}">{$event['event_title']}</a>
                    {if $event['event_privacy'] == "public"}
                        <i data-toggle="tooltip" data-placement="top" title='{__("Public Event")}' class="fa fa-globe fa-fw privacy-badge"></i>
                    {elseif $event['event_privacy'] == "closed"}
                        <i data-toggle="tooltip" data-placement="top" title='{__("Closed Event")}' class="fa fa-unlock-alt fa-fw privacy-badge"></i>
                    {elseif $event['event_privacy'] == "secret"}
                        <i data-toggle="tooltip" data-placement="top" title='{__("Secret Event")}' class="fa fa-lock fa-fw privacy-badge"></i>
                    {/if}
                </div>
                <div class="profle-meta-wrapper">
                    <i class="fa fa-clock-o"></i> {$event['event_start_date']|date_format:"%I:%M %p"} - {$event['event_end_date']|date_format:"%b %e %I:%M %p"}
                </div>
                <!-- profile-name -->

                <!-- profile-buttons -->
                <div class="profile-buttons-wrapper">
                    {if $event['event_privacy'] == "public" || $event['i_joined'] || $event['event_admin'] == $user->_data['user_id']}
                        {if $event['i_joined']['is_going']}
                            <button type="button" class="btn btn-default js_ungo-event" data-id="{$event['event_id']}">
                                <i class="fa fa-check"></i> {__("Going")}
                            </button>
                        {else}
                            <button type="button" class="btn btn-success js_go-event" data-id="{$event['event_id']}">
                                <i class="fa fa-calendar-check-o"></i> {__("Going")}
                            </button>
                        {/if}
                        {if $event['i_joined']['is_interested']}
                            <button type="button" class="btn btn-default js_uninterest-event" data-id="{$event['event_id']}">
                                <i class="fa fa-check"></i> {__("Interested")}
                            </button>
                        {else}
                            <button type="button" class="btn btn-primary js_interest-event" data-id="{$event['event_id']}">
                                <i class="fa fa-star"></i> {__("Interested")}
                            </button>
                        {/if}
                    {/if}

                    {if $user->_data['user_id'] == $event['event_admin']}
                        <a href="{$system['system_url']}/events/{$event['event_id']}/settings" class="btn btn-default">
                            <i class="fa fa-cog"></i> {__("Settings")}
                        </a>
                    {else}
                        <a href="#" class="btn btn-default js_report" data-handle="event" data-id="{$event['event_id']}">
                            <i class="fa fa-flag"></i> {__("Report")}
                        </a>
                    {/if}
                </div>
                <!-- profile-buttons -->

                <!-- profile-tabs -->
                <div class="profile-tabs-wrapper">
                    <ul class="nav">
                        {if $event['event_privacy'] == "public" || $event['i_joined'] || $event['event_admin'] == $user->_data['user_id']}
                            <li>
                                <a href="{$system['system_url']}/events/{$event['event_id']}">
                                    {__("Timeline")}
                                </a>
                            </li>
                            <li class="middle-tabs">
                                <a href="{$system['system_url']}/events/{$event['event_id']}/photos">
                                    {__("Photos")}
                                </a>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    {__("More")}
                                    <i class="caret"></i>
                                </a>
                                <ul class="dropdown-menu">
                                    <li class="middle-tabs-alt">
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/photos">{__("Photos")}</a>
                                    </li>
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/albums">{__("Albums")}</a>
                                    </li>
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/going">{__("Going")}</a>
                                    </li>
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/interested">{__("Interested")}</a>
                                    </li>
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/invited">{__("Invited")}</a>
                                    </li>
                                    {if $event['i_joined']}
                                        <li>
                                            <a href="{$system['system_url']}/events/{$event['event_id']}/invites">{__("Invite Friends")}</a>
                                        </li>
                                    {/if}
                                </ul>
                            </li>
                        {else}
                            <li>
                                <a href="{$system['system_url']}/events/{$event['event_id']}">
                                    {__("About")}
                                </a>
                            </li>
                        {/if}
                    </ul>
                </div>
                <!-- profile-tabs -->
            </div>
            <!-- profile-header -->

            <!-- profile-content -->
            <div class="row">
                <!-- profile-buttons alt -->
                <div class="col-sm-12">
                    <div class="panel panel-default profile-buttons-wrapper-alt">
                        <div class="panel-body">
                            {if $event['event_privacy'] == "public" || $event['i_joined'] || $event['event_admin'] == $user->_data['user_id']}
                                {if $event['i_joined']['is_going']}
                                    <button type="button" class="btn btn-default js_ungo-event" data-id="{$event['event_id']}">
                                        <i class="fa fa-check"></i> {__("Going")}
                                    </button>
                                {else}
                                    <button type="button" class="btn btn-success js_go-event" data-id="{$event['event_id']}">
                                        <i class="fa fa-calendar-check-o"></i> {__("Going")}
                                    </button>
                                {/if}
                                {if $event['i_joined']['is_interested']}
                                    <button type="button" class="btn btn-default js_uninterest-event" data-id="{$event['event_id']}">
                                        <i class="fa fa-check"></i> {__("Interested")}
                                    </button>
                                {else}
                                    <button type="button" class="btn btn-primary js_interest-event" data-id="{$event['event_id']}">
                                        <i class="fa fa-star"></i> {__("Interested")}
                                    </button>
                                {/if}
                            {/if}

                            <div class="pull-right flip">
                                {if $user->_data['user_id'] == $event['event_admin']}
                                    <a href="{$system['system_url']}/events/{$event['event_id']}/settings" class="btn btn-default">
                                        <i class="fa fa-cog"></i> {__("Settings")}
                                    </a>
                                {else}
                                    <a href="#" class="btn btn-default js_report" data-handle="event" data-id="{$event['event_id']}">
                                        <i class="fa fa-flag"></i> {__("Report")}
                                    </a>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
                <!-- profile-buttons alt -->

                <!-- view content -->
                {if $view == ""}
                    <!-- right panel -->
                    <div class="col-sm-4 col-md-push-8">
                        <!-- about -->
                        <div class="panel panel-default">
                            <div class="panel-body">
                                {if !is_empty($event['event_description'])}
                                    <div class="about-bio">
                                        {$event['event_description']}
                                    </div>
                                {/if}
                                <ul class="about-list">
                                    <li>
                                        <div class="about-list-item">
                                            {if $event['event_privacy'] == "public"}
                                                <i class="fa fa-globe fa-fw fa-lg"></i>
                                                {__("Public Event")}
                                            {elseif $event['event_privacy'] == "closed"}
                                                <i class="fa fa-unlock-alt fa-fw fa-lg"></i>
                                                {__("Closed Event")}
                                            {elseif $event['event_privacy'] == "secret"}
                                                <i class="fa fa-lock fa-fw fa-lg"></i>
                                                {__("Secret Event")}
                                            {/if}
                                        </div>
                                    </li>
                                    <li>
                                        <div class="about-list-item">
                                            <i class="fa fa-clock-o fa-fw fa-lg"></i>
                                            {$event['event_start_date']|date_format:"%B %e"} - {$event['event_end_date']|date_format:"%B %e"}<br>
                                            <small class="text-muted">{$event['event_start_date']|date_format:"%b %e %I:%M %p"} {__("to")} {$event['event_end_date']|date_format:"%b %e %I:%M %p"}</small>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="about-list-item">
                                            <i class="fa fa-user fa-fw fa-lg"></i>
                                            {__("Hosted By")} <a target="_blank" href="{$system['system_url']}/{$event['user_name']}">{$event['user_firstname']} {$event['user_lastname']}</a>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="about-list-item">
                                            <i class="fa fa-map-marker fa-fw fa-lg"></i>
                                            {$event['event_location']}
                                        </div>
                                    </li>
                                    <li>
                                        <div class="about-list-item">
                                            <i class="fa fa-calendar-check-o fa-fw fa-lg"></i>
                                            <a href="{$system['system_url']}/events/{$event['event_id']}/going">{$event['event_going']} {__("Going")}</a>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="about-list-item">
                                            <i class="fa fa-star fa-fw fa-lg"></i>
                                            <a href="{$system['system_url']}/events/{$event['event_id']}/interested">{$event['event_interested']} {__("Interested")}</a>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="about-list-item">
                                            <i class="fa fa-envelope-open fa-fw fa-lg"></i>
                                            <a href="{$system['system_url']}/events/{$event['event_id']}/invited">{$event['event_invited']} {__("Invited")}</a>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <!-- about -->

                        <!-- invite friends -->
                        {if $event['i_joined'] && $event['invites']}
                            <div class="panel panel-default">
                                <div class="panel-heading light no_border">
                                    <div class="pull-right flip">
                                        <small><a href="{$system['system_url']}/events/{$event['event_id']}/invites">{__("See All")}</a></small>
                                    </div>
                                    <strong class="text-muted">{__("Invite Friends")}</strong>
                                </div>
                                <div class="panel-body ptb5 plr5">
                                    <ul>
                                        {foreach $event['invites'] as $_user}
                                        {include file='__feeds_user.tpl' _connection=$_user["connection"] _small=true}
                                        {/foreach}
                                    </ul>
                                </div>
                            </div>
                        {/if}
                        <!-- invite friends -->

                        <!-- photos -->
                        {if $event['photos']}
                            <div class="panel panel-default panel-photos">
                                <div class="panel-heading">
                                    <a href="{$system['system_url']}/events/{$event['event_id']}/photos">{__("Photos")}</a>
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        {foreach $event['photos'] as $photo}
                                            {include file='__feeds_photo.tpl' _context="photos" _small=true}
                                        {/foreach}
                                    </div>
                                </div>
                            </div>
                        {/if}
                        <!-- photos -->
                    </div>
                    <!-- right panel -->

                    <!-- left panel -->
                    <div class="col-sm-8 col-md-pull-4">
                        <!-- publisher -->
                        {if $event['i_joined']}
                            {include file='_publisher.tpl' _handle="event" _id=$event['event_id']}
                        {/if}
                        <!-- publisher -->

                        <!-- pinned post -->
                        {if $pinned_post}
                            {include file='_pinned_post.tpl' post=$pinned_post _get="posts_event"}
                        {/if}
                        <!-- pinned post -->

                        <!-- posts -->
                        {include file='_posts.tpl' _get="posts_event" _id=$event['event_id']}
                        <!-- posts -->
                    </div>
                    <!-- left panel -->
                {elseif $view == "photos"}
                    <!-- photos -->
                    <div class="col-xs-12">
                        <div class="panel panel-default panel-photos">
                            <div class="panel-heading with-icon with-nav">
                                <!-- panel title -->
                                <div class="mb20">
                                    <i class="fa fa-picture-o pr5 panel-icon"></i>
                                    <strong>{__("Photos")}</strong>
                                </div>
                                <!-- panel title -->

                                <!-- panel nav -->
                                <ul class="nav nav-tabs">
                                    <li class="active">
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/photos">
                                            <strong class="pr5">{__("Photos")}</strong>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/albums">{__("Albums")}</a>
                                    </li>
                                </ul>
                                <!-- panel nav -->
                            </div>
                            <div class="panel-body">
                                {if count($event['photos']) > 0}
                                    <ul class="row">
                                        {foreach $event['photos'] as $photo}
                                            {include file='__feeds_photo.tpl' _context="photos"}
                                        {/foreach}
                                    </ul>
                                    {if count($event['photos']) >= $system['min_results_even']}
                                        <!-- see-more -->
                                        <div class="alert alert-info see-more js_see-more" data-get="photos" data-id="{$event['event_id']}" data-type='event'>
                                            <span>{__("See More")}</span>
                                            <div class="loader loader_small x-hidden"></div>
                                        </div>
                                        <!-- see-more -->
                                    {/if}
                                {else}
                                    <p class="text-center text-muted mt10">
                                        {$event['event_title']} {__("doesn't have photos")}
                                    </p>
                                {/if}
                            </div>
                        </div>
                    </div>
                    <!-- photos -->
                {elseif $view == "albums"}
                    <!-- albums -->
                    <div class="col-xs-12">
                        <div class="panel panel-default panel-albums">
                            <div class="panel-heading with-icon with-nav">
                                <!-- panel title -->
                                <div class="mb20">
                                    <i class="fa fa-picture-o pr5 panel-icon"></i>
                                    <strong>{__("Photos")}</strong>
                                </div>
                                <!-- panel title -->

                                <!-- panel nav -->
                                <ul class="nav nav-tabs">
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/photos">{__("Photos")}</a>
                                    </li>
                                    <li class="active">
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/albums">
                                            <strong class="pr5">{__("Albums")}</strong>
                                        </a>
                                    </li>
                                </ul>
                                <!-- panel nav -->
                            </div>
                            <div class="panel-body">
                                {if count($event['albums']) > 0}
                                    <ul class="row">
                                        {foreach $event['albums'] as $album}
                                        {include file='__feeds_album.tpl'}
                                        {/foreach}
                                    </ul>
                                    {if count($event['albums']) >= $system['max_results_even']}
                                        <!-- see-more -->
                                        <div class="alert alert-info see-more js_see-more" data-get="albums" data-id="{$event['event_id']}" data-type='event'>
                                            <span>{__("See More")}</span>
                                            <div class="loader loader_small x-hidden"></div>
                                        </div>
                                        <!-- see-more -->
                                    {/if}
                                {else}
                                    <p class="text-center text-muted mt10">
                                        {$event['event_title']} {__("doesn't have albums")}
                                    </p>
                                {/if}
                            </div>
                        </div>
                    </div>
                    <!-- albums -->
                {elseif $view == "album"}
                    <!-- albums -->
                    <div class="col-xs-12">
                        <div class="panel panel-default panel-albums">
                            <div class="panel-heading with-icon with-nav">
                                <!-- back to albums -->
                                <div class="pull-right flip">
                                    <a href="{$system['system_url']}/events/{$event['event_id']}/albums" class="btn btn-default btn-sm">
                                        <i class="fa fa-arrow-circle-left"></i> {__("Back to Albums")}
                                    </a>
                                </div>
                                <!-- back to albums -->
                                
                                <!-- panel title -->
                                <div class="mb20">
                                    <i class="fa fa-picture-o pr5 panel-icon"></i>
                                    <strong>{__("Photos")}</strong>
                                </div>
                                <!-- panel title -->

                                <!-- panel nav -->
                                <ul class="nav nav-tabs">
                                    <li>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/photos">{__("Photos")}</a>
                                    </li>
                                    <li class="active">
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/albums">
                                            <strong class="pr5">{__("Albums")}</strong>
                                        </a>
                                    </li>
                                </ul>
                                <!-- panel nav -->
                            </div>
                            <div class="panel-body">
                            {include file='_album.tpl'}
                            </div>
                        </div>
                    </div>
                    <!-- albums -->
                {elseif $view == "going" || $view == "interested" || $view == "invited" || $view == "invites"}
                    <!-- members -->
                    <div class="col-xs-12">
                        <div class="panel panel-default">
                            <div class="panel-heading with-icon with-nav">

                                <!-- panel title -->
                                <div class="mb20">
                                    <i class="fa fa-users pr5 panel-icon"></i>
                                    <strong>{__("Members")}</strong>
                                </div>
                                <!-- panel title -->

                                <!-- panel nav -->
                                <ul class="nav nav-tabs">
                                    <li {if $view == "going"}class="active"{/if}>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/going">
                                            <strong class="pr5">{__("Going")}</strong>
                                            <span class="label label-info ml5">{$event['event_going']}</span>
                                        </a>
                                    </li>
                                    <li {if $view == "interested"}class="active"{/if}>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/interested">
                                            <strong class="pr5">{__("Interested")}</strong>
                                            <span class="label label-info ml5">{$event['event_interested']}</span>
                                        </a>
                                    </li>
                                    <li {if $view == "invited"}class="active"{/if}>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/invited">
                                            <strong class="pr5">{__("Invited")}</strong>
                                            <span class="label label-info ml5">{$event['event_invited']}</span>
                                        </a>
                                    </li>
                                    {if $event['i_joined']}
                                        <li {if $view == "invites"}class="active"{/if}>
                                            <a href="{$system['system_url']}/events/{$event['event_id']}/invites">
                                                <strong class="pr5">{__("Invites")}</strong>
                                            </a>
                                        </li>
                                    {/if}
                                </ul>
                                <!-- panel nav -->
                            </div>
                            <div class="panel-body">
                                {if $event['total_members'] > 0}
                                    <ul class="row">
                                        {foreach $event['members'] as $_user}
                                        {include file='__feeds_user.tpl' _connection=$_user["connection"] _parent="profile"}
                                        {/foreach}
                                    </ul>

                                    {if $event['total_members'] >= $system['max_results_even']}
                                        <!-- see-more -->
                                        <div class="alert alert-info see-more js_see-more" data-get="event_{$view}" data-id="{$event['event_id']}">
                                            <span>{__("See More")}</span>
                                            <div class="loader loader_small x-hidden"></div>
                                        </div>
                                        <!-- see-more -->
                                    {/if}
                                {else}
                                    <p class="text-center text-muted mt10">
                                        {if $view == "invites"}
                                            {__("No friends to invite")}
                                        {else}
                                            {__("No people available")}
                                        {/if}
                                    </p>
                                {/if}
                            </div>
                        </div>
                    </div>
                    <!-- members -->
                {elseif $view == "settings"}
                    <div class="col-sm-3">
                        <div class="panel panel-default">
                            <div class="panel-body with-nav">
                                <ul class="side-nav">
                                    <li {if $sub_view == ""}class="active"{/if}>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/settings"><i class="fa fa-cog fa-fw fa-lg pr10"></i> {__("Event Settings")}</a>
                                    </li>
                                    <li {if $sub_view == "delete"}class="active"{/if}>
                                        <a href="{$system['system_url']}/events/{$event['event_id']}/settings/delete"><i class="fa fa-trash fa-fw fa-lg pr10"></i> {__("Delete Event")}</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-9">
                        <!-- edit -->
                        <div class="panel panel-default">
                            {if $sub_view == ""}
                                <div class="panel-heading with-icon">
                                    <!-- panel title -->
                                    <i class="fa fa-cog pr5 panel-icon"></i>
                                    <strong>{__("Event Settings")}</strong>
                                    <!-- panel title -->
                                </div>
                                <div class="panel-body">
                                    <form class="js_ajax-forms" data-url="pages_groups_events/create.php?type=event&do=edit&id={$event['event_id']}">
                                        <div class="form-group">
                                            <label for="title">{__("Name Your Event")}</label>
                                            <input type="text" class="form-control" name="title" id="title" value="{$event['event_title']}">
                                        </div>
                                        <div class="form-group">
                                            <label for="location">{__("Location")}</label>
                                            <input type="text" class="form-control" name="location" id="location" value="{$event['event_location']}">
                                        </div>
                                        <div class="form-group">
                                            <label>{__("Start Date")}</label>
                                            <div class='input-group date js_datetimepicker'>
                                                <input type='text' class="form-control" name="start_date" value="{get_datetime($event['event_start_date'])}" />
                                                <span class="input-group-addon">
                                                    <span class="fa fa-calendar"></span>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>{__("End Date")}</label>
                                            <div class='input-group date js_datetimepicker'>
                                                <input type='text' class="form-control" name="end_date" value="{get_datetime($event['event_end_date'])}" />
                                                <span class="input-group-addon">
                                                    <span class="fa fa-calendar"></span>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="privacy">{__("Select Privacy")}</label>
                                            <select class="form-control selectpicker" name="privacy">
                                                <option {if $event['event_privacy'] == "public"}selected{/if} value="public" data-content="<div class='option'><div class='icon'><i class='fa fa-globe fa-2x'></i></div><div class='text'><b>{__('Public Event')}</b><br>{__('Anyone can see the event, its users and posts')}.
                                                </div></div>">{__("Public Event")}</option>
                                                <option {if $event['event_privacy'] == "closed"}selected{/if} value="closed" data-content="<div class='option'><div class='icon'><i class='fa fa-unlock-alt fa-2x'></i></div><div class='text'><b>{__('Closed Event')}</b><br>{__('Only event users can see posts')}.
                                                </div></div>">{__("Closed Event")}</option>
                                                <option {if $event['event_privacy'] == "secret"}selected{/if} value="secret" data-content="<div class='option'><div class='icon'><i class='fa fa-lock fa-2x'></i></div><div class='text'><b>{__('Secret Event')}</b><br>{__('Only invited users and event users can find the event')}.
                                                </div></div>">{__("Secret Event")}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="category">{__("Category")}</label>
                                            <select class="form-control" name="category">
                                                {foreach $categories as $category}
                                                    <option {if $event['event_category'] == $category['category_id']}selected{/if} value="{$category['category_id']}">{__($category['category_name'])}</option>
                                                {/foreach}
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="description">{__("About")}</label>
                                            <textarea class="form-control" name="description">{$event['event_description']}</textarea>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">{__("Save")}</button>

                                        <!-- error -->
                                        <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                                        <!-- error -->
                                    </form>
                                </div>
                            {elseif $sub_view == "delete"}
                                <div class="panel-heading with-icon">
                                    <!-- panel title -->
                                    <i class="fa fa-trash pr5 panel-icon"></i>
                                    <strong>{__("Delete Event")}</strong>
                                    <!-- panel title -->
                                </div>
                                <div class="panel-body">
                                    <div class="alert alert-warning">
                                        <i class="fa fa-exclamation-triangle fa-lg mr10"></i>{__("Once you delete your event you will no longer can access it again")}
                                    </div>
                                    <div class="text-center">
                                        <button class="btn btn-danger js_delete-event" data-id="{$event['event_id']}">
                                            <i class="fa fa-trash-o"></i>
                                            {__("Delete Event")}
                                        </button>
                                    </div>
                                </div>
                            {/if}
                        </div>
                        <!-- edit -->
                    </div>
                {elseif $view == "about"}
                    <!-- info -->
                    <div class="col-xs-12">
                        <div class="panel panel-default">
                            <div class="panel-heading with-icon">
                                <strong>{__("About")}</strong>
                            </div>
                            <div class="panel-body">
                                {__("This event is private and you need to be invited to see its info, members and posts")}
                            </div>
                        </div>
                    </div>
                    <!-- info -->
                {/if}
                <!-- view content -->
            </div>
            <!-- profile-content -->
        </div>
        <!-- right panel -->

    </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}