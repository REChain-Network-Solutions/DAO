<!-- need pro package -->
{capture name='locked_cta'}
  {if $_manage}
    <a class="heroui button button--tertiary text-base-content h-auto min-h-11 max-w-full gap-2 px-6 py-2.5 leading-snug whitespace-normal text-balance rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/membership">
      <span class="icon-[tabler--settings] size-5 shrink-0" aria-hidden="true"></span>
      <span>{__("Manage Allowed Categories")}</span>
    </a>
  {/if}
{/capture}
{include file='__locked_content.tpl' _icon="icon-[tabler--lock]" _title=__("You can't access this category") _meta='' _text='' _image='' _cta=$smarty.capture.locked_cta _framed=$_framed _compact=$_compact}
<!-- need pro package -->
