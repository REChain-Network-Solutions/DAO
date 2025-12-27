{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page header -->
<div class="page-header">
  <img class="floating-img d-none d-md-block" src="{$system['system_url']}/content/themes/{$system['theme']}/images/headers/undraw_active-support_v6g0.svg">
  <div class="circle-2"></div>
  <div class="circle-3"></div>
  <div class="inner">
    <h2>{__("Support Center")}</h2>
    <p class="text-xlg">{__("Fast Track Your Issue to Our Experts")}</p>
  </div>
</div>
<!-- page header -->

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} sg-offcanvas" style="margin-top: -25px;">

  <div class="position-relative">
    <!-- tabs -->
    <div class="content-tabs rounded-sm shadow-sm clearfix">
      <ul>
        <li class="active">
          <a href="{$system['system_url']}/support/tickets">{__("Support Tickets")}</a>
        </li>
      </ul>
      {if !$user->_is_admin && !$user->_is_moderator}
        <div class="mt10 float-end">
          <a href="{$system['system_url']}/support/tickets/new" class="btn btn-md btn-primary d-none d-lg-block">
            <i class="fa fa-plus-circle mr5"></i>{__("Create Ticket")}
          </a>
          <a href="{$system['system_url']}/support/tickets/new" class="btn btn-sm btn-icon btn-primary d-block d-lg-none">
            <i class="fa fa-plus-circle"></i>
          </a>
        </div>
      {/if}
    </div>
    <!-- tabs -->
  </div>

  <div class="row">

    <!-- left panel -->
    <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar">
      {if $view == "ticket"}
        <div class="card">
          <div class="card-header with-icon">
            <i class="fa-solid fa-ticket mr5"></i>{__("Ticket Details")}
          </div>
          <div class="card-body plr30">
            <!-- requester -->
            <div>
              <div class="mb5"><strong>{__("Requester")}</strong></div>
              <div>
                <a target="_blank" href="{$system['system_url']}/{$ticket['requester_username']}">
                  <img class="tbl-image" src="{$ticket['requester_picture']}">
                  {$ticket['requester_fullname']}
                </a>
              </div>
            </div>
            <!-- requester -->
            <div class="divider mtb10"></div>
            <!-- agent -->
            <div>
              <div class="mb5"><strong>{__("Agent")}</strong></div>
              <div>
                {if $ticket['agent_id']}
                  {if $user->_is_admin || $user->_is_moderator}
                    <a target="_blank" href="{$system['system_url']}/{$ticket['agent_username']}">
                      <img class="tbl-image" src="{$ticket['agent_picture']}">
                      {$ticket['agent_fullname']}
                    </a>
                  {else}
                    {__("Support Agent")}
                  {/if}
                {else}
                  <span class="badge bg-light text-primary">{__("Unassigned")}</span>
                {/if}
              </div>
            </div>
            <!-- agent -->
            <div class="divider mtb10"></div>
            <!-- status -->
            <div>
              <div class="mb5"><strong>{__("Status")}</strong></div>
              <div>
                {if $ticket['status'] == "opened"}
                  <span class="badge bg-primary">{__("Opened")}</span>
                {elseif $ticket['status'] == "in_progress"}
                  <span class="badge bg-info">{__("In Progress")}</span>
                {elseif $ticket['status'] == "pending"}
                  <span class="badge bg-warning">{__("Pending")}</span>
                {elseif $ticket['status'] == "solved"}
                  <span class="badge bg-success">{__("Solved")}</span>
                {elseif $ticket['status'] == "closed"}
                  <span class="badge bg-danger">{__("Closed")}</span>
                {/if}
              </div>
            </div>
            <!-- status -->
            <div class="divider mtb10"></div>
            <!-- last update -->
            <div>
              <div class="mb5"><strong>{__("Last Update")}</strong></div>
              <div>
                <span class="js_moment" data-time="{$ticket['updated_at']}">{$ticket['updated_at']}</span>
              </div>
            </div>
            <!-- last update -->
            <div class="divider mtb10"></div>
            <!-- created at -->
            <div>
              <div class="mb5"><strong>{__("Created At")}</strong></div>
              <div>
                <span class="js_moment" data-time="{$ticket['created_at']}">{$ticket['created_at']}</span>
              </div>
            </div>
            <!-- created at -->
          </div>
        </div>
      {else}
        <!-- categories -->
        <div class="card">
          <div class="card-body with-nav">
            <ul class="side-nav">
              <li {if $view == "" || $view == "tickets" && !$status && !$unassigned}class="active" {/if}>
                <a href="{$system['system_url']}/support/tickets">
                  {__("All")}<span class="badge bg-secondary float-end">{$tickets_stats['total']}</span>
                </a>
              </li>
              {if $user->_is_admin}
                <li {if $unassigned}class="active" {/if}>
                  <a href="{$system['system_url']}/support/tickets?unassigned=true">
                    {__("Unassigned")}<span class="badge bg-light text-danger float-end">{$tickets_stats['unassigned']}</span>
                  </a>
                </li>
              {/if}
              <li {if $status == "in_progress"}class="active" {/if}>
                <a href="{$system['system_url']}/support/tickets?status=in_progress">
                  {__("In Progress")}<span class="badge bg-light text-info float-end">{$tickets_stats['in_progress']}</span>
                </a>
              </li>
              <li>
                <div class="divider"></div>
              </li>
              <li {if $status == "opened"}class="active" {/if}>
                <a href="{$system['system_url']}/support/tickets?status=opened">
                  {__("Open")}<span class="badge bg-light text-primary float-end">{$tickets_stats['opened']}</span>
                </a>
              </li>
              <li {if $status == "pending"}class="active" {/if}>
                <a href="{$system['system_url']}/support/tickets?status=pending">
                  {__("Pending")}<span class="badge bg-light text-warning float-end">{$tickets_stats['pending']}</span>
                </a>
              </li>
              <li {if $status == "solved"}class="active" {/if}>
                <a href="{$system['system_url']}/support/tickets?status=solved">
                  {__("Solved")}<span class="badge bg-light text-success float-end">{$tickets_stats['solved']}</span>
                </a>
              </li>
              <li {if $status == "closed"}class="active" {/if}>
                <a href="{$system['system_url']}/support/tickets?status=closed">
                  {__("Closed")}<span class="badge bg-light text-danger float-end">{$tickets_stats['closed']}</span>
                </a>
              </li>
            </ul>
          </div>
        </div>
        <!-- categories -->
      {/if}
    </div>
    <!-- left panel -->

    <!-- content panel -->
    <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">

      {if $view == "" || $view == "tickets" || $view == "find"}

        <div class="card">
          <div class="card-header with-icon">
            {include file='__svg_icons.tpl' icon="support" class="main-icon mr5" width="24px" height="24px"}
            {__("Tickets")} {if $view == "find"} &rsaquo; {__("Search")}{/if}
          </div>
          <div class="card-body">

            <!-- search form -->
            <div class="mb20">
              <form class="d-flex flex-row align-items-center flex-wrap" action="{$system['system_url']}/support/tickets/find" method="get">
                <div class="form-group mb0">
                  <div class="input-group">
                    <input type="text" class="form-control" name="query" value="{$query}">
                    <button type="submit" class="btn btn-sm btn-light"><i class="fas fa-search mr5"></i>{__("Search")}</button>
                  </div>
                </div>
              </form>
              <div class="form-text small">
                {__("Search by Subject or TicketID")}
              </div>
            </div>
            <!-- search form -->

            <div class="table-responsive">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>{__("ID")}</th>
                    <th>{__("Requester")}</th>
                    <th>{__("Subject")}</th>
                    <th>{__("Agent")}</th>
                    <th>{__("Status")}</th>
                    <th>{__("Last Update")}</th>
                  </tr>
                </thead>
                <tbody>
                  {if $tickets}
                    {foreach $tickets as $ticket}
                      <tr>
                        <td>{$ticket['ticket_id']}</td>
                        <td>
                          <a target="_blank" href="{$system['system_url']}/{$ticket['requester_username']}">
                            <img class="tbl-image" src="{$ticket['requester_picture']}">
                            {$ticket['requester_fullname']}
                          </a>
                        </td>
                        <td>
                          <a href="{$system['system_url']}/support/tickets/{$ticket['ticket_id']}" title="{$ticket['subject']}">{$ticket['subject']|truncate:30}</a>
                        </td>
                        <td>
                          {if $ticket['agent_id']}
                            {if $user->_is_admin || $user->_is_moderator}
                              <a target="_blank" href="{$system['system_url']}/{$ticket['agent_username']}">
                                <img class="tbl-image" src="{$ticket['agent_picture']}">
                                {$ticket['agent_fullname']}
                              </a>
                            {else}
                              {__("Support Agent")}
                            {/if}
                          {else}
                            <span class="badge bg-light text-primary">{__("Unassigned")}</span>
                          {/if}
                        </td>
                        <td>
                          {if $ticket['status'] == "opened"}
                            <span class="badge bg-primary">{__("Opened")}</span>
                          {elseif $ticket['status'] == "in_progress"}
                            <span class="badge bg-info">{__("In Progress")}</span>
                          {elseif $ticket['status'] == "pending"}
                            <span class="badge bg-warning">{__("Pending")}</span>
                          {elseif $ticket['status'] == "solved"}
                            <span class="badge bg-success">{__("Solved")}</span>
                          {elseif $ticket['status'] == "closed"}
                            <span class="badge bg-danger">{__("Closed")}</span>
                          {/if}
                        </td>
                        <td>
                          <span class="js_moment" data-time="{$ticket['updated_at']}">{$ticket['updated_at']}</span>
                        </td>
                      </tr>
                    {/foreach}
                  {else}
                    <tr>
                      <td colspan="6" class="text-center">
                        {__("No data to show")}
                      </td>
                    </tr>
                  {/if}
                </tbody>
              </table>
            </div>
            {$pager}
          </div>
        </div>

      {elseif $view == "ticket"}

        <div class="posts-filter pb10">
          <span>{$ticket['subject']}</span>
          {if $user->_is_admin || $user->_is_moderator}
            <div class="float-end">
              <button class="btn btn-sm btn-secondary" data-toggle="modal" data-url="support/ticket.php?do=update&ticket_id={$ticket['ticket_id']}">
                {__("Update")}
              </button>
            </div>
          {/if}
        </div>
        <!-- ticket -->
        <div class="forum-thread">
          <div class="row">
            <div class="col-12 col-sm-2 text-center">
              <a href="{$system['system_url']}/{$ticket['requester_username']}"><img class="avatar" src="{$ticket['requester_picture']}"></a>
              <h6 class="mt10">
                <a href="{$system['system_url']}/{$ticket['requester_username']}">{$ticket['requester_fullname']}</a>
              </h6>
              <div class="mb5">
                <i class="fa fa-user"></i> {__("Member")}
              </div>
            </div>
            <div class="col-12 col-sm-10">
              <div class="time clearfix">
                <!-- time -->
                <small><i class="far fa-clock"></i> <span class="js_moment" data-time="{$ticket['created_at']}">{$ticket['created_at']}</span></small>
                <!-- time -->
              </div>
              <div class="text">
                {$ticket['parsed_text']}
              </div>
            </div>
          </div>
        </div>
        <!-- ticket -->

        <!-- replies -->
        {if $ticket['replies']}
          {foreach $ticket['replies'] as $reply}
            <div class="forum-thread">
              <div class="row">
                <div class="col-12 col-sm-2 text-center">
                  {if $user->_is_admin || $user->_is_moderator}
                    <a href="{$system['system_url']}/{$reply['user_name']}"><img class="avatar" src="{$reply['user_picture']}"></a>
                  {else}
                    <img class="avatar" src="{$reply['user_picture']}">
                  {/if}
                  <h6 class="mt10">
                    {if $user->_is_admin || $user->_is_moderator}
                      <a href="{$system['system_url']}/{$reply['user_name']}">{$reply['user_fullname']}</a>
                    {else}
                      {$reply['user_fullname']}
                    {/if}
                  </h6>
                  <div class="mb5">
                    {if $user->_is_admin || $user->_is_moderator}
                      {if $reply['user_group'] == 1}
                        <i class="fa fa-shield-alt"></i> {__("Admin")}
                      {elseif $reply['user_group'] == 2}
                        <i class="fab fa-black-tie"></i> {__("Moderator")}
                      {else}
                        <i class="fa fa-user"></i> {__("Member")}
                      {/if}
                    {/if}
                  </div>
                </div>
                <div class="col-12 col-sm-10">
                  <div class="time clearfix">
                    <!-- time -->
                    <small><i class="far fa-clock"></i> <span class="js_moment" data-time="{$reply['created_at']}">{$reply['created_at']}</span></small>
                    <!-- time -->
                  </div>
                  <div class="text">
                    {$reply['parsed_text']}
                  </div>
                </div>
              </div>
            </div>
          {/foreach}
        {/if}
        <!-- replies -->

        <!-- reply form -->
        <div class="card mt20">
          <div class="card-header with-icon">
            <i class="fa-solid fa-comment-dots mr5"></i>{__("Post Reply")}
          </div>
          <div class="js_ajax-forms-html" data-url="support/ticket.php?do=reply&id={$ticket['ticket_id']}">
            <div class="card-body">
              <textarea name="text" class="form-control js_wysiwyg"></textarea>
              <!-- error -->
              <div class="alert alert-danger mt15 mb0 x-hidden"></div>
              <!-- error -->
            </div>
            <div class="card-footer text-end">
              <button type="submit" class="btn btn-primary">{__("Submit")}</button>
            </div>
          </div>
        </div>

      {elseif $view == "new"}

        <div class="card">
          <div class="card-header with-icon">
            <i class="fa-solid fa-ticket mr5"></i>{__("Create New Ticket")}
          </div>
          <div class="js_ajax-forms-html" data-url="support/ticket.php?do=create">
            <div class="card-body">
              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Subject")}
                </label>
                <div class="col-md-10">
                  <input class="form-control" name="subject">
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Content")}
                </label>
                <div class="col-md-10">
                  <textarea name="text" class="form-control js_wysiwyg"></textarea>
                </div>
              </div>

              <!-- error -->
              <div class="alert alert-danger mt15 mb0 x-hidden"></div>
              <!-- error -->
            </div>
            <div class="card-footer text-end">
              <button type="submit" class="btn btn-primary">{__("Submit")}</button>
            </div>
          </div>
        </div>

      {/if}

    </div>
    <!-- content panel -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}