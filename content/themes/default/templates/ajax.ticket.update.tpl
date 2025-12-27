<div class="modal-header">
  <h6 class="modal-title">
    {__("Update Ticket")} #{$ticket['ticket_id']}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="support/ticket.php?do=edit">
  <div class="modal-body">
    <!-- status -->
    <div class="form-group">
      <label class="form-label">{__("Status")}</label>
      <select class="form-select" name="status">
        <option value="opened" {if $ticket['status'] == "opened"}selected{/if}>{__("Opened")}</option>
        <option value="in_progress" {if $ticket['status'] == "in_progress"}selected{/if}>{__("In Progress")}</option>
        <option value="pending" {if $ticket['status'] == "pending"}selected{/if}>{__("Pending")}</option>
        <option value="solved" {if $ticket['status'] == "solved"}selected{/if}>{__("Solved")}</option>
        <option value="closed" {if $ticket['status'] == "closed"}selected{/if}>{__("Closed")}</option>
      </select>
    </div>
    <!-- status -->

    {if $user->_is_admin}
      <!-- agent -->
      <div class="form-group">
        <label class="form-label">{__("Agent")}</label>
        <select class="form-select" name="agent_id">
          <option value="0">{__("Unassigned")}</option>
          {foreach $agents as $agent}
            <option value="{$agent['user_id']}" {if $ticket['agent_id'] == $agent['user_id']}selected{/if}>{$agent['user_fullname']}</option>
          {/foreach}
        </select>
      </div>
      <!-- agent -->
    {/if}

    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <input type="hidden" name="ticket_id" value="{$ticket['ticket_id']}">
    <button type="submit" class="btn btn-primary">{__("Update")}</button>
  </div>
</form>