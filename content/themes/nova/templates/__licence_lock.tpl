{if !$_mini}
  {assign var="_lock_rows" value=6}
{/if}
<div class="admin-licence-lock{if $_mini} admin-licence-lock-mini{/if} admin-licence-lock-{$licence_lock['type']}" role="status" aria-labelledby="admin-licence-lock-title">
  {if !$_mini}
    <div class="admin-licence-lock-backdrop" aria-hidden="true">
      {for $row=1 to $_lock_rows}
        <div class="admin-licence-lock-row">
          <div class="admin-licence-lock-avatar"></div>
          <div class="admin-licence-lock-lines">
            <div class="admin-licence-lock-line"></div>
            <div class="admin-licence-lock-line short"></div>
          </div>
          <div class="admin-licence-lock-toggle"></div>
        </div>
      {/for}
    </div>
  {/if}
  <div class="admin-licence-lock-message">
    <div class="admin-licence-lock-card">
      <div class="admin-licence-lock-icon">
        {if $licence_lock['type'] == "success"}
          <span class="icon-[tabler--circle-check] size-6" aria-hidden="true"></span>
        {else}
          <span class="icon-[tabler--lock] size-6" aria-hidden="true"></span>
        {/if}
      </div>
      <div class="admin-licence-lock-body">
        {if $_title}
          <h2 id="admin-licence-lock-title">{$_title}</h2>
          <p>{$licence_lock['title']}</p>
        {else}
          <h2 id="admin-licence-lock-title">{$licence_lock['title']}</h2>
          <p>{$licence_lock['text']}</p>
        {/if}
      </div>
      <div class="admin-licence-lock-actions">
        <a class="heroui button button--primary" href="{$licence_lock['url']}">
          <span class="icon-[tabler--key] size-4" aria-hidden="true"></span>
          {__("Go to License Page")}
        </a>
      </div>
    </div>
  </div>
</div>
