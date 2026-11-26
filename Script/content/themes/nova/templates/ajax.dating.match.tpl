<div class="modal__body flex flex-col items-center gap-5 py-4 text-center">
  <div class="flex items-center justify-center">
    <img class="size-24 rounded-full object-cover ring-4 ring-base-100" src="{$user->_data['user_picture']}" alt="">
    <img class="-ms-6 size-24 rounded-full object-cover ring-4 ring-base-100" src="{$card['photos'][0]}" alt="">
  </div>
  <div>
    <h6 class="text-2xl font-bold text-primary">{__("It's a Match!")}</h6>
    <p class="mt-1 text-sm text-base-content/60">{__("You and")} <strong class="text-base-content">{$card['name']}</strong> {__("liked each other")}</p>
  </div>
</div>
<div class="modal__footer justify-center gap-2">
  <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Keep Swiping")}</button>
  {if $system['chat_enabled'] && $match}
    <button type="button" class="button button--primary js_chat-start" data-overlay="#modal" data-uid="{$match['user_id']}" data-name="{$match['fullname']}" data-link="{$match['user_name']}" data-picture="{$match['picture']}">{__("Send a Message")}</button>
  {/if}
</div>
