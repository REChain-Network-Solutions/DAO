<div class="comment-replace min-w-0">
  <div class="comment-text js_readmore text-sm leading-5 wrap-break-word" data-lines="{$system['comments_read_more_lines']|default:3}" dir="auto">{$_comment['text']}</div>
  <div class="comment-text-plain hidden">{$_comment['text_plain']}</div>
  {if $_comment['image'] != ""}
    <span class="text-primary cursor-pointer js_lightbox-nodata" data-image="{$system['system_uploads']}/{$_comment['image']}">
      <img alt="" class="mt-2 max-h-48 max-w-full rounded-field object-cover" src="{$system['system_uploads']}/{$_comment['image']}">
    </span>
  {/if}
  {if !empty($_comment['gif'])}
    <img alt="GIF" class="mt-2 block max-h-48 max-w-full rounded-field" src="{$_comment['gif']}" loading="lazy">
  {/if}
  {if $_comment['voice_note'] != ""}
    <audio class="js_audio mt-2 min-w-50 max-w-full" id="audio-{$_comment['comment_id']}" controls preload="auto">
      <source src="{$system['system_uploads']}/{$_comment['voice_note']}" type="audio/mpeg">
      <source src="{$system['system_uploads']}/{$_comment['voice_note']}" type="audio/mp3">
      {__("Your browser does not support HTML5 audio")}
    </audio>
  {/if}
</div>
