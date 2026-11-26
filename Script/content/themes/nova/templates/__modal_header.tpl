<div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
  {if $_icon}
    <span class="modal__icon size-9 rounded-lg {if $_danger}bg-error/10 text-error{else}bg-base-200 text-base-content{/if}" aria-hidden="true">
      <span class="{$_icon} size-5"></span>
    </span>
  {/if}
  <div class="min-w-0 flex-1">
    <h6 class="modal__heading">{$_title}</h6>
    {if $_text}
      <p class="text-sm text-base-content/60">{$_text}</p>
    {/if}
  </div>
  {if !$_no_close}
    {include file='__close_button.tpl' extra_class="static"}
  {/if}
</div>
