{foreach $announcements as $announcement}
  <div class="flex items-start gap-3 rounded-box p-3 sm:p-4 {if $announcement['type'] == "success"}border border-success/20 bg-success/10{elseif $announcement['type'] == "warning"}border border-warning/25 bg-warning/10{elseif $announcement['type'] == "danger"}border border-error/20 bg-error/10{else}border border-info/20 bg-info/10{/if}" role="status">
    <div class="min-w-0 grow self-center break-words">
      {if $announcement['title']}<h3 class="font-semibold text-base-content">{$announcement['title']}</h3>{/if}
      <div class="text-sm text-base-content/70 [&_a]:link [&_a]:link-primary">{$announcement['code']}</div>
    </div>
    {if $user->_logged_in}
      <button type="button" class="js_announcment-remover heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full shrink-0 text-base-content/60" data-id="{$announcement['announcement_id']}" aria-label='{__("Close")}' title='{__("Close")}'>
        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
      </button>
    {/if}
  </div>
{/foreach}
