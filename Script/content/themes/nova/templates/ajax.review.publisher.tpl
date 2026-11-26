<div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
  <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--star] size-5"></span></span>
  <div class="min-w-0 flex-1">
    <h6 class="modal__heading">{__("Review")} {$node_title}</h6>
  </div>
  {include file='__close_button.tpl' extra_class="static"}
</div>
<form class="publisher-mini" data-id="{$node_id}" data-type="{$node_type}">
  <div class="modal__body flex flex-col gap-4">
    <!-- rating -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Rating")}</span>
      <div class="js_star-rating flex flex-row-reverse justify-end gap-1">
        <input type="radio" class="sr-only" id="star5" name="rating" value="5" />
        <label for="star5" class="cursor-pointer text-base-content/20 transition-colors hover:text-warning [input:checked~&]:text-warning [label:hover~&]:text-warning"><span class="icon-[tabler--star-filled] size-7" aria-hidden="true"></span><span class="sr-only">5</span></label>
        <input type="radio" class="sr-only" id="star4" name="rating" value="4" />
        <label for="star4" class="cursor-pointer text-base-content/20 transition-colors hover:text-warning [input:checked~&]:text-warning [label:hover~&]:text-warning"><span class="icon-[tabler--star-filled] size-7" aria-hidden="true"></span><span class="sr-only">4</span></label>
        <input type="radio" class="sr-only" id="star3" name="rating" value="3" />
        <label for="star3" class="cursor-pointer text-base-content/20 transition-colors hover:text-warning [input:checked~&]:text-warning [label:hover~&]:text-warning"><span class="icon-[tabler--star-filled] size-7" aria-hidden="true"></span><span class="sr-only">3</span></label>
        <input type="radio" class="sr-only" id="star2" name="rating" value="2" />
        <label for="star2" class="cursor-pointer text-base-content/20 transition-colors hover:text-warning [input:checked~&]:text-warning [label:hover~&]:text-warning"><span class="icon-[tabler--star-filled] size-7" aria-hidden="true"></span><span class="sr-only">2</span></label>
        <input type="radio" class="sr-only" id="star1" name="rating" value="1" />
        <label for="star1" class="cursor-pointer text-base-content/20 transition-colors hover:text-warning [input:checked~&]:text-warning [label:hover~&]:text-warning"><span class="icon-[tabler--star-filled] size-7" aria-hidden="true"></span><span class="sr-only">1</span></label>
      </div>
    </div>
    <!-- rating -->
    <!-- review -->
    <div class="w-full">
      <label class="label-text mb-1.5 block">{__("Write Your Review")}</label>
      <textarea name="review" rows="5" dir="auto" class="textarea w-full [--border:1px]"></textarea>
    </div>
    <!-- review -->
    <!-- photos -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Photos")}</span>
      <div class="attachments [&_ul]:grid [&_ul]:grid-cols-3 [&_ul]:items-start [&_ul]:gap-2 [&_li]:relative [&_li]:overflow-hidden [&_li]:rounded-field [&_li]:bg-base-200 [&_img]:size-full [&_img]:object-cover [&_.button]:absolute [&_.button]:end-1 [&_.button]:top-1 [&_.name]:p-2 [&_.name]:text-xs [&_.name]:break-all" data-type="photos">
        <ul>
          <li class="add grid aspect-square place-items-center border border-dashed border-base-300 text-base-content/60 hover:text-base-content [&>.x-uploader]:absolute [&>.x-uploader]:inset-0 [&>.x-uploader]:z-10 [&>.x-uploader]:grid [&>.x-uploader]:cursor-pointer [&>.x-uploader]:place-items-center [&>.x-uploader]:overflow-hidden [&>.x-uploader>input[type=file]]:absolute [&>.x-uploader>input[type=file]]:inset-0 [&>.x-uploader>input[type=file]]:z-10 [&>.x-uploader>input[type=file]]:size-full [&>.x-uploader>input[type=file]]:cursor-pointer [&>.x-uploader>input[type=file]]:opacity-0">
            <span class="icon-[tabler--camera-plus] size-6 js_x-uploader" data-handle="publisher-mini" data-multiple="true" aria-hidden="true"></span>
          </li>
        </ul>
      </div>
    </div>
    <!-- photos -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="button" class="button button--primary js_publisher-btn js_publisher-review">{__("Submit")}</button>
  </div>
</form>
