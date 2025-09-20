{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-12 w-100">
		{if $user->_data['can_publish_posts']}
			<!-- share to options -->
			<div class="p-3">
				<div class="form-label fw-medium">
					{__("Share to")}
				</div>
			
				<div class="d-flex align-items-center flex-wrap gap-3 pb-1">
					<!-- timeline -->
					<input class="x-hidden input-label" type="radio" name="share_to" id="share_to_timeline" value="timeline" checked="checked" />
					<label class="button-label m-0 px-3 py-2" for="share_to_timeline">
						<div class="title m-0">{__("Timeline")}</div>
					</label>
					<!-- timeline -->
					
					<!-- page -->
					{if $system['pages_enabled'] && $pages}
						<input class="x-hidden input-label" type="radio" name="share_to" id="share_to_page" value="page" />
						<label class="button-label m-0 px-3 py-2" for="share_to_page">
							<div class="title m-0">{__("Page")}</div>
						</label>
					{/if}
					<!-- page -->
			  
					<!-- group -->
					{if $system['groups_enabled'] && $groups}
						<input class="x-hidden input-label" type="radio" name="share_to" id="share_to_group" value="group" />
						<label class="button-label m-0 px-3 py-2" for="share_to_group">
							<div class="title m-0">{__("Group")}</div>
						</label>
					{/if}
					<!-- group -->
			  
					<!-- event -->
					{if $system['events_enabled'] && $events}
						<input class="x-hidden input-label" type="radio" name="share_to" id="share_to_event" value="event" />
						<label class="button-label m-0 px-3 py-2" for="share_to_event">
							<div class="title m-0">{__("Event")}</div>
						</label>
					{/if}
					<!-- event -->
				</div>

				<!-- share to page -->
				<div id="js_share-to-page" class="mt-3 x-hidden">
					<div class="form-floating">
						<select class="form-select" name="page">
							{foreach $pages as $page}
								<option value="{$page['page_name']}">{$page['page_title']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("Select Page")}</label>
					</div>
					<div class="form-group text-end">
						<button type="submit" class="btn btn-primary js_select-share-page">{__("Select")}</button>
					</div>
				</div>
				<!-- share to page -->

				<!-- share to group -->
				<div id="js_share-to-group" class="mt-3 x-hidden">
					<div class="form-floating">
						<select class="form-select" name="group">
							{foreach $groups as $group}
								<option value="{$group['group_name']}">{$group['group_title']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("Select Group")}</label>
					</div>
					<div class="form-group text-end">
						<button type="submit" class="btn btn-primary js_select-share-group">{__("Select")}</button>
					</div>
				</div>
				<!-- share to group -->

				<!-- share to event -->
				<div id="js_share-to-event" class="mt-3 x-hidden">
					<div class="form-floating">
						<select class="form-select" name="event">
							{foreach $events as $event}
								<option value="{$event['event_id']}">{$event['event_title']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("Select Event")}</label>
					</div>
					<div class="form-group text-end">
						<button type="submit" class="btn btn-primary js_select-share-event">{__("Select")}</button>
					</div>
				</div>
				<!-- share to event -->
			</div>
			<!-- share to options -->
			
			<hr class="mt-1 mb-2">

			<!-- publisher -->
			<div id="js_share-to-timeline">
				{include file='_publisher.tpl' _handle="me" _node_can_monetize_content=$user->_data['can_monetize_content'] _node_monetization_enabled=$user->_data['user_monetization_enabled'] _node_monetization_plans=$user->_data['user_monetization_plans'] _privacy=true}
			</div>
			<!-- publisher -->
			
		{else}
			<div class="p-3 text-muted text-center py-5">
				<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="text-danger text-opacity-75"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3.25C10.067 3.25 8.49999 4.817 8.49999 6.75V8.31016C9.61772 8.27048 10.7654 8.25 12 8.25C13.2346 8.25 14.3823 8.27048 15.5 8.31016V6.75C15.5 4.817 13.933 3.25 12 3.25ZM6.49999 6.75V8.52712C4.93232 9.00686 3.74924 10.3861 3.52451 12.0552C3.37635 13.1556 3.24999 14.3118 3.24999 15.5C3.24999 16.6882 3.37636 17.8444 3.52451 18.9448C3.79608 20.9618 5.46715 22.5555 7.52521 22.6501C8.95364 22.7158 10.4042 22.75 12 22.75C13.5958 22.75 15.0464 22.7158 16.4748 22.6501C18.5328 22.5555 20.2039 20.9618 20.4755 18.9448C20.6236 17.8444 20.75 16.6882 20.75 15.5C20.75 14.3118 20.6236 13.1556 20.4755 12.0552C20.2507 10.3861 19.0677 9.00686 17.5 8.52712V6.75C17.5 3.71243 15.0376 1.25 12 1.25C8.96243 1.25 6.49999 3.71243 6.49999 6.75ZM13 14.5C13 13.9477 12.5523 13.5 12 13.5C11.4477 13.5 11 13.9477 11 14.5V16.5C11 17.0523 11.4477 17.5 12 17.5C12.5523 17.5 13 17.0523 13 16.5V14.5Z" fill="currentColor"/></svg>

				<div class="text-md mt-4">
					<h5 class="headline-font m-0">
						{__("Permission Denied")}
					</h5>
				</div>
				
				<div class="post-paid-description mt-2">
					{__("You are not allowed to publish posts")}
				</div>
			</div>
		{/if}

    </div>
    <!-- content panel -->
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