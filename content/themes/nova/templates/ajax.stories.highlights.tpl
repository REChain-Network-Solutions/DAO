{include file='__modal_header.tpl' _icon="icon-[tabler--star]" _title=__("Add to Highlight")}
<div class="modal__body flex flex-col gap-4">
  {if $highlights}
    <ul class="flex flex-col gap-1">
      {foreach $highlights as $highlight}
        <li class="flex items-center gap-3 rounded-xl p-2">
          <span class="flex size-11 shrink-0 items-center justify-center overflow-hidden rounded-full bg-linear-to-br from-primary to-accent text-white">
            {if $highlight['cover']}
              <img class="size-full object-cover" src="{$highlight['cover']}" alt="" loading="lazy">
            {else}
              <span class="icon-[tabler--star] size-5" aria-hidden="true"></span>
            {/if}
          </span>
          <span class="min-w-0 flex-1 truncate text-sm font-semibold" title="{$highlight['title']}">{$highlight['title']}</span>
          <form class="js_ajax-forms contents" data-url="stories/highlights.php?do=toggle&amp;story_id={$story_id}&amp;id={$highlight['highlight_id']}">
            {if $highlight['has_story']}
              <button type="submit" class="button button--tertiary text-base-content button--sm shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                {__("Added")}
              </button>
            {else}
              <button type="submit" class="button button--primary button--sm shrink-0">{__("Add")}</button>
            {/if}
          </form>
          <button type="button" class="button button--danger-soft button--sm button--icon-only shrink-0 js_story-highlight-delete" data-url="stories/highlights.php?do=delete&amp;story_id={$story_id}&amp;id={$highlight['highlight_id']}" title='{__("Delete")}' aria-label='{__("Delete")}'>
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
          </button>
        </li>
      {/foreach}
    </ul>
  {/if}

  <form class="js_ajax-forms flex flex-col gap-3" data-url="stories/highlights.php?do=create&amp;story_id={$story_id}">
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="story-highlight-title">{__("New Highlight")}</label>
      <div class="flex items-center gap-2">
        <input type="text" class="input w-full [--border:1px]" name="title" id="story-highlight-title" maxlength="30" autocomplete="off" dir="auto" placeholder='{__("Highlight name")}'>
        <button type="submit" class="button button--primary shrink-0">{__("Create")}</button>
      </div>
    </div>
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </form>
</div>
