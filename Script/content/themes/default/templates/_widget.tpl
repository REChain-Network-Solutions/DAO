{if $widgets}
  <!-- Widgets -->
  {foreach $widgets as $widget}
    {if $widget['target_audience'] == 'all' || ($widget['target_audience'] == 'visitors' && !$user->_logged_in) || ($widget['target_audience'] == 'members' && $user->_logged_in)}
      <div class="card">
        <div class="card-header">
          <strong>{__({$widget['title']})}</strong>
        </div>
        <div class="card-body">{$widget['code']}</div>
      </div>
    {/if}
  {/foreach}
  <!-- Widgets -->
{/if}