{if $_status == "opened"}
  <span class="badge badge-soft badge-primary gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Opened")}</span>
{elseif $_status == "in_progress"}
  <span class="badge badge-soft badge-info gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("In Progress")}</span>
{elseif $_status == "pending"}
  <span class="badge badge-soft badge-warning gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Pending")}</span>
{elseif $_status == "solved"}
  <span class="badge badge-soft badge-success gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Solved")}</span>
{elseif $_status == "closed"}
  <span class="badge badge-soft badge-error gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Closed")}</span>
{/if}
