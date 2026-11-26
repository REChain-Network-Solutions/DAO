{if $system['geolocation_provider'] == "openstreetmap"}
  {$_latitude = $latitude|string_format:"%.7F"}
  {$_longitude = $longitude|string_format:"%.7F"}
  {if $latitude != '' && $longitude != '' && ($_latitude != 0 || $_longitude != 0)}
    <!-- map -->
    <div class="{$_class}">
      <iframe class="{$_frame_class}" loading="lazy" title='{$_title}' src="https://www.openstreetmap.org/export/embed.html?bbox={($_longitude - 0.01)|string_format:"%.7F"}%2C{($_latitude - 0.01)|string_format:"%.7F"}%2C{($_longitude + 0.01)|string_format:"%.7F"}%2C{($_latitude + 0.01)|string_format:"%.7F"}&amp;layer=mapnik&amp;marker={$_latitude}%2C{$_longitude}"></iframe>
    </div>
    <!-- map -->
  {elseif !$_no_link}
    <!-- map link -->
    <div class="{$_link_class}">
      <a class="inline-flex min-w-0 items-center gap-1.5 text-sm font-medium text-primary hover:underline" href="https://www.openstreetmap.org/search?query={$location|html_entity_decode|escape:'url'}" target="_blank" rel="noopener">
        <span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span>{__("View on Map")}
      </a>
    </div>
    <!-- map link -->
  {/if}
{else}
  <!-- map -->
  <div class="{$_class}">
    <iframe class="{$_frame_class}" loading="lazy" title='{$_title}' src="https://www.google.com/maps/embed/v1/place?key={$system['geolocation_key']}&amp;q={$location|html_entity_decode|escape:'url'}"></iframe>
  </div>
  <!-- map -->
{/if}
