{if $widgets}
  <!-- Widgets -->
  {foreach $widgets as $widget}
    {if $widget['target_audience'] == 'all' || ($widget['target_audience'] == 'visitors' && !$user->_logged_in) || ($widget['target_audience'] == 'members' && $user->_logged_in)}
      <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-primary/10 shadow-none text-sm">
        {include file='__card_header.tpl' _card_title=__($widget['title'])}
        <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block break-words px-5 py-4 [&_iframe]:max-w-full [&_img]:max-w-full [&_table]:w-full">{$widget['code']}</div>
      </div>
    {/if}
  {/foreach}
  <!-- Widgets -->
{/if}
