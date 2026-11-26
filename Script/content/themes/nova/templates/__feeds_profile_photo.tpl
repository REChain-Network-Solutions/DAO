<li>
  <button type="button" class="pg_photo block aspect-square w-full cursor-pointer overflow-hidden rounded-box bg-base-200 bg-cover bg-center transition hover:opacity-90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $_filter == "avatar"}js_profile-picture-change{else}js_profile-cover-change{/if}" data-id={$id} data-type={$type} data-image="{$photo['source']}" style="background-image:url({$system['system_uploads']}/{$photo['source']});" aria-label='{__("Select Photo")}'></button>
</li>
