<div class="post-replace text-[0.9375rem] leading-6">
  {if is_array($post['colored_pattern'])}
    <div class="post-colored mx-4 flex min-h-72 items-center justify-center overflow-hidden rounded-box bg-cover bg-center p-7 text-center" {if $post['colored_pattern']['type'] == "color"} style="background-image: linear-gradient(45deg, {$post['colored_pattern']['background_color_1']}, {$post['colored_pattern']['background_color_2']});" {else} style="background-image: url({$system['system_uploads']}/{$post['colored_pattern']['background_image']})" {/if}>
      <div class="post-colored-text-wrapper js_scroller flex max-h-60 w-full items-center justify-center overflow-y-auto" data-slimScroll-height="240">
        <div class="post-text text-xl font-semibold leading-8" dir="auto" style="color: {$post['colored_pattern']['text_color']};">
          {$post['text']}
        </div>
      </div>
    </div>
  {else}
    <div class="post-text js_readmore px-4 pb-2 text-start wrap-break-word" dir="auto">{$post['text']}</div>
  {/if}
  <div class="post-text-translation mx-4 mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
  <div class="post-text-plain hidden">{$post['text_plain']}</div>
</div>
