{include file='__modal_header.tpl' _icon="icon-[tabler--bolt]" _title=__("Edit your shortcuts")}
<div class="js_shortcuts modal__body flex flex-col gap-4">
  <p class="text-sm text-base-content/60">{__("Shortcuts give you quick access to what you use most. They are sorted automatically, but you can pin something so it is always shown at the top or hide it from the list.")}</p>

  <input type="text" class="js_shortcuts-search input w-full [--border:1px]" autocomplete="off" dir="auto" placeholder='{__("Search your pages, groups, events and games")}' aria-label='{__("Search your pages, groups, events and games")}'>

  <div class="js_shortcuts-list flex flex-col gap-3">
    {include file='ajax.shortcuts.list.tpl'}
  </div>
</div>
<form class="js_ajax-forms contents" data-url="users/shortcuts.php?do=save">
  <div class="js_shortcuts-staged hidden"></div>

  <!-- error -->
  <div class="alert alert-soft alert-error alert-danger hidden"></div>
  <!-- error -->

  <div class="modal__footer mt-4 justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>
