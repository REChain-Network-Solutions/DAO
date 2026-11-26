<article class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
  <div class="flex items-center gap-3 border-b border-base-300 px-4 py-3">
    {if $_link}
      <a class="shrink-0" href="{$_link}"><img class="size-10 rounded-full object-cover" src="{$_picture}" alt=""></a>
    {else}
      <img class="size-10 shrink-0 rounded-full object-cover" src="{$_picture}" alt="">
    {/if}
    <div class="min-w-0 grow">
      {if $_role == 1}
        <div class="text-xs text-base-content/60">{__("Admin")}</div>
      {elseif $_role == 2}
        <div class="text-xs text-base-content/60">{__("Moderator")}</div>
      {elseif $_role == 3}
        <div class="text-xs text-base-content/60">{__("Member")}</div>
      {elseif $_agent}
        <div class="text-xs text-base-content/60">{__("Support Agent")}</div>
      {/if}
      {if $_link}
        <a class="block truncate text-sm font-semibold text-base-content! transition-colors hover:text-primary!" href="{$_link}" title="{$_name}">{$_name}</a>
      {else}
        <span class="block truncate text-sm font-semibold" title="{$_name}">{$_name}</span>
      {/if}
    </div>
    <span class="js_moment shrink-0 text-xs text-base-content/60" data-time="{$_time}">{$_time}</span>
  </div>
  <div class="min-w-0 break-words px-4 py-4 text-sm leading-relaxed text-base-content/85 [&_a]:text-primary [&_a]:underline [&_blockquote]:border-s-4 [&_blockquote]:border-base-300 [&_blockquote]:ps-4 [&_img]:h-auto [&_img]:max-w-full [&_img]:rounded-xl [&_ol]:list-decimal [&_ol]:ps-6 [&_p]:mb-3 [&_pre]:overflow-x-auto [&_pre]:rounded-xl [&_pre]:bg-base-200 [&_pre]:p-4 [&_ul]:list-disc [&_ul]:ps-6">
    {$_text}
  </div>
</article>
