{include file='__modal_header.tpl' _icon="icon-[tabler--school]" _title=__("Apply to course")}
<form class="js_ajax-forms" data-url="posts/course.php?do=apply&post_id={$post['post_id']}">
  <div class="modal__body flex flex-col gap-4">
    <p class="text-base font-semibold text-base-content wrap-break-word">{$post['course']['title']}</p>
    <h3 class="text-sm font-semibold text-base-content">{__("Your Information")}</h3>
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- name -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-application-name">{__("Name")}</label>
        <input id="course-application-name" name="name" type="text" autocomplete="name" class="input w-full [--border:1px]" value="{$user->_data['user_fullname']}" required>
      </div>
      <!-- name -->
      <!-- location -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-application-location">{__("Location")}</label>
        <input id="course-application-location" name="location" type="text" autocomplete="address-level2" class="input w-full [--border:1px]" required>
      </div>
      <!-- location -->
    </div>
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- phone -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-application-phone">{__("Phone")}</label>
        <input id="course-application-phone" name="phone" type="tel" autocomplete="tel" class="input w-full [--border:1px]" value="{$user->_data['user_phone']}" required>
      </div>
      <!-- phone -->
      <!-- email -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-application-email">{__("Email")}</label>
        <input id="course-application-email" name="email" type="email" autocomplete="email" class="input w-full [--border:1px]" value="{$user->_data['user_email']}" required>
      </div>
      <!-- email -->
    </div>
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden" role="alert"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Submit application")}</button>
  </div>
</form>
