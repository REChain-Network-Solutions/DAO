<div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
  <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--ticket] size-5"></span></span>
  <div class="min-w-0 flex-1">
    <h6 class="modal__heading">{__("Update Ticket")} #{$ticket['ticket_id']}</h6>
  </div>
  {include file='__close_button.tpl' extra_class="static"}
</div>
<form class="js_ajax-forms" data-url="support/ticket.php?do=edit">
  <div class="modal__body flex flex-col gap-4">
    <!-- status -->
    <div class="w-full">
      <label class="label-text mb-1.5 block">{__("Status")}</label>
      <select class="select w-full [--border:1px]" name="status">
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
      <div class="w-full">
        <label class="label-text mb-1.5 block">{__("Agent")}</label>
        <select class="select w-full [--border:1px]" name="agent_id">
          <option value="0">{__("Unassigned")}</option>
          {foreach $agents as $agent}
            <option value="{$agent['user_id']}" {if $ticket['agent_id'] == $agent['user_id']}selected{/if}>{$agent['user_fullname']}</option>
          {/foreach}
        </select>
      </div>
      <!-- agent -->
    {/if}

    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="ticket_id" value="{$ticket['ticket_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Update")}</button>
  </div>
</form>
