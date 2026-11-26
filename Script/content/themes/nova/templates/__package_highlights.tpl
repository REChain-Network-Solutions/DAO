<li>
  <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
  <span>{__("Featured member")}</span>
</li>
{if $system['packages_ads_free_enabled']}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{__("No Ads")}</span>
  </li>
{/if}
{if $package['verification_badge_enabled']}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{__("Verified Badge")}</span>
  </li>
{/if}
{if $package['free_points'] > 0}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{$package['free_points']} {__("Free Points")}</span>
  </li>
{/if}
{if $package['boost_posts_enabled']}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{__("Boost up to")} {$package['boost_posts']} {__("Posts")}</span>
  </li>
{/if}
{if $package['boost_pages_enabled']}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{__("Boost up to")} {$package['boost_pages']} {__("Pages")}</span>
  </li>
{/if}
{if $package['boost_groups_enabled']}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{__("Boost up to")} {$package['boost_groups']} {__("Groups")}</span>
  </li>
{/if}
{if $package['boost_events_enabled']}
  <li>
    <span class="icon-[tabler--circle-check-filled] mt-0.5 size-4 shrink-0 text-primary" aria-hidden="true"></span>
    <span>{__("Boost up to")} {$package['boost_events']} {__("Events")}</span>
  </li>
{/if}
