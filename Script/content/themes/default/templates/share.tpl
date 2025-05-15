{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20">
  <div class="row">

    <!-- content panel -->
    <div class="col-12">
      {if $user->_data['can_publish_posts']}
        <!-- share to options -->
        <div class="card">
          <div class="card-body">
            <div class="h5 text-center">
              {__("Share to")}
            </div>
            <div class="mb20 text-center">
              <!-- timeline -->
              <input class="x-hidden input-label" type="radio" name="share_to" id="share_to_timeline" value="timeline" checked="checked" />
              <label class="button-label small" for="share_to_timeline">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="20px" height="20px"}
                </div>
                <div class="title">{__("Timeline")}</div>
              </label>
              <!-- timeline -->
              <!-- page -->
              {if $system['pages_enabled'] && $pages}
                <input class="x-hidden input-label" type="radio" name="share_to" id="share_to_page" value="page" />
                <label class="button-label small" for="share_to_page">
                  <div class="icon">
                    {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="20px" height="20px"}
                  </div>
                  <div class="title">{__("Page")}</div>
                </label>
              {/if}
              <!-- page -->
              <!-- group -->
              {if $system['groups_enabled'] && $groups}
                <input class="x-hidden input-label" type="radio" name="share_to" id="share_to_group" value="group" />
                <label class="button-label small" for="share_to_group">
                  <div class="icon">
                    {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="20px" height="20px"}
                  </div>
                  <div class="title">{__("Group")}</div>
                </label>
              {/if}
              <!-- group -->
              <!-- event -->
              {if $system['events_enabled'] && $events}
                <input class="x-hidden input-label" type="radio" name="share_to" id="share_to_event" value="event" />
                <label class="button-label small" for="share_to_event">
                  <div class="icon">
                    {include file='__svg_icons.tpl' icon="events" class="main-icon" width="20px" height="20px"}
                  </div>
                  <div class="title">{__("Event")}</div>
                </label>
              {/if}
              <!-- event -->
            </div>

            <!-- share to page -->
            <div id="js_share-to-page" class="x-hidden">
              <div class="form-group">
                <label class="form-label">{__("Select Page")}</label>
                <select class="form-select" name="page">
                  {foreach $pages as $page}
                    <option value="{$page['page_name']}">{$page['page_title']}</option>
                  {/foreach}
                </select>
              </div>
              <div class="form-group text-end">
                <button type="submit" class="btn btn-primary js_select-share-page">{__("Select")}</button>
              </div>
            </div>
            <!-- share to page -->

            <!-- share to group -->
            <div id="js_share-to-group" class="x-hidden">
              <div class="form-group">
                <label class="form-label">{__("Select Group")}</label>
                <select class="form-select" name="group">
                  {foreach $groups as $group}
                    <option value="{$group['group_name']}">{$group['group_title']}</option>
                  {/foreach}
                </select>
              </div>
              <div class="form-group text-end">
                <button type="submit" class="btn btn-primary js_select-share-group">{__("Select")}</button>
              </div>
            </div>
            <!-- share to group -->

            <!-- share to event -->
            <div id="js_share-to-event" class="x-hidden">
              <div class="form-group">
                <label class="form-label">{__("Select Event")}</label>
                <select class="form-select" name="event">
                  {foreach $events as $event}
                    <option value="{$event['event_id']}">{$event['event_title']}</option>
                  {/foreach}
                </select>
              </div>
              <div class="form-group text-end">
                <button type="submit" class="btn btn-primary js_select-share-event">{__("Select")}</button>
              </div>
            </div>
            <!-- share to event -->
          </div>
        </div>
        <!-- share to options -->

        <!-- publisher -->
        <div id="js_share-to-timeline">
          {include file='_publisher.tpl' _handle="me" _node_can_monetize_content=$user->_data['can_monetize_content'] _node_monetization_enabled=$user->_data['user_monetization_enabled'] _node_monetization_plans=$user->_data['user_monetization_plans'] _privacy=true}
        </div>
        <!-- publisher -->
      {else}
        <div class="card">
          <div class="card-body">
            <div class="text-center">
              <div class="h5">{__("Permission Denied")}</div>
              <div class="text-muted">{__("You are not allowed to publish posts")}</div>
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

<script>
  // handle share
  /* share to options */
  $('input[type=radio][name=share_to]').on('change', function() {
    switch ($(this).val()) {
      case 'timeline':
        $('#js_share-to-timeline').fadeIn();
        $('#js_share-to-page').hide();
        $('#js_share-to-group').hide();
        $('#js_share-to-event').hide();
        break;
      case 'page':
        $('#js_share-to-timeline').hide();
        $('#js_share-to-page').fadeIn();
        $('#js_share-to-group').hide();
        $('#js_share-to-event').hide();
        break;
      case 'group':
        $('#js_share-to-timeline').hide();
        $('#js_share-to-page').hide();
        $('#js_share-to-group').fadeIn();
        $('#js_share-to-event').hide();
        break;
      case 'event':
        $('#js_share-to-timeline').hide();
        $('#js_share-to-page').hide();
        $('#js_share-to-group').hide();
        $('#js_share-to-event').fadeIn();
        break;
    }
  });
  /* select share to */
  $('.js_select-share-page').on('click', function() {
    var page = $('select[name=page]').val();
    if (page) {
      window.location.href = '{$system['system_url']}/pages/' + page + '?url=' + encodeURIComponent('{$url}') + '#publisher-box';
    }
  });

  $('.js_select-share-group').on('click', function() {
    var group = $('select[name=group]').val();
    if (group) {
      window.location.href = '{$system['system_url']}/groups/' + group + '?url=' + encodeURIComponent('{$url}') + '#publisher-box';
    }
  });

  $('.js_select-share-event').on('click', function() {
    var event = $('select[name=event]').val();
    if (event) {
      window.location.href = '{$system['system_url']}/events/' + event + '?url=' + encodeURIComponent('{$url}') + '#publisher-box';
    }
  });
</script>