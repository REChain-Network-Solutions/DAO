<div class="mt-2 overflow-hidden bg-base-200">
  {if $_post['photos_num'] == 1}
    <div class="{if $_post['photos'][0]['blur']}x-blured overflow-hidden{/if}">
      <a href="{$system['system_url']}/photos/{$_post['photos'][0]['photo_id']}" class="js_lightbox flex max-h-[42rem] w-full items-center justify-center bg-base-200 {if $_post['photos'][0]['blur']}blur-md{/if}" data-id="{$_post['photos'][0]['photo_id']}" data-image="{$system['system_uploads']}/{$_post['photos'][0]['source']}" data-context="{if in_array($_post['post_type'], ['product', 'offer'])}post{else}album{/if}">
        <img class="max-h-[42rem] w-full object-contain" src="{$system['system_uploads']}/{$_post['photos'][0]['source']}" alt="">
      </a>
    </div>
  {elseif $_post['photos_num'] > 1}
    {assign var="photo_grid" value=($_post['photo_layout']|default:'classic')|photo_layout:$_post['photos_num']}
    <div class="{$photo_grid['container']}">
      {foreach $_post['photos'] as $photo}
        {if $photo@index < $photo_grid['visible']}
          <div class="min-h-0 min-w-0 overflow-hidden {if $photo@first}{$photo_grid['first']}{/if} {$photo_grid['tile']} {if $photo@index is odd}{$photo_grid['offset']}{/if} {if $photo_grid['mobile'] && $photo@index >= $photo_grid['mobile']}max-sm:hidden{/if} {if $photo['blur']}x-blured{/if}">
            <a href="{$system['system_url']}/photos/{$photo['photo_id']}" class="js_lightbox relative block h-full w-full bg-cover bg-center transition-transform duration-200 hover:scale-[1.01] motion-reduce:transition-none {if $photo['blur']}blur-md{/if}" data-id="{$photo['photo_id']}" data-image="{$system['system_uploads']}/{$photo['source']}" data-context="post" style="background-image:url('{$system['system_uploads']}/{$photo['source']}');">
              {if $photo@index == $photo_grid['visible'] - 1 && $_post['photos_num'] > $photo_grid['visible']}
                <span class="more absolute inset-0 flex items-center justify-center bg-black/50 text-3xl font-semibold text-white">+{$_post['photos_num']-$photo_grid['visible']}</span>
              {/if}
              {if $photo_grid['mobile'] && $photo@index == $photo_grid['mobile'] - 1 && $_post['photos_num'] > $photo_grid['mobile']}
                <span class="more absolute inset-0 flex items-center justify-center bg-black/50 text-3xl font-semibold text-white sm:hidden">+{$_post['photos_num']-$photo_grid['mobile']}</span>
              {/if}
            </a>
          </div>
        {/if}
      {/foreach}
    </div>
  {/if}
</div>
