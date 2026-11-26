<!-- posts filter -->
<select class="js_posts-filter hidden" aria-label='{__("All")}' data-select='{ "optionAllowEmptyOption": true, "wrapperClasses": "shrink-0", "toggleTag": "<button type=\"button\" aria-expanded=\"false\"><span data-icon class=\"flex! size-4 shrink-0 [&>*]:size-4\"></span><span data-title class=\"hidden\"></span></button>", "toggleClasses": "advance-select-toggle h-8 border-0 bg-base-100 ps-2.5 pe-7 shadow-none hover:bg-base-300", "dropdownClasses": "advance-select-menu end-0 start-auto z-50 mt-2 max-h-80 w-48 space-y-1 overflow-y-auto opacity-0 transition-opacity duration-300 select-opened:opacity-100", "optionClasses": "advance-select-option px-3 py-2 text-sm selected:select-active", "optionTemplate": "<div class=\"flex w-full items-center gap-2\"><span data-icon class=\"flex size-5 shrink-0\"></span><span data-title class=\"min-w-0 grow\"></span><span class=\"icon-[tabler--check] hidden size-4 shrink-0 text-primary selected:block\"></span></div>", "extraMarkup": "<span class=\"pointer-events-none absolute end-2.5 top-1/2 z-1 flex -translate-y-1/2 text-base-content/50\"><span class=\"icon-[tabler--chevron-down] size-3.5\"></span></span>" }'>
  <option value="all" selected data-select-option='{ "icon": "<span class=\"icon-[tabler--menu-2] size-5\"></span>" }'>{__("All")}</option>
  <option value="" data-select-option='{ "icon": "<span class=\"icon-[tabler--align-left] size-5\"></span>" }'>{__("Text")}</option>
  <option value="link" data-select-option='{ "icon": "<span class=\"icon-[tabler--link] size-5\"></span>" }'>{__("Links")}</option>
  <option value="media" data-select-option='{ "icon": "<span class=\"icon-[tabler--library-photo] size-5\"></span>" }'>{__("Media")}</option>
  {if $system['live_enabled'] && $_get != "posts_page" && $_get != "posts_group" && $_get != "posts_event"}
    <option value="live" data-select-option='{ "icon": "<span class=\"icon-[tabler--broadcast] size-5\"></span>" }'>{__("Live")}</option>
  {/if}
  <option value="photos" data-select-option='{ "icon": "<span class=\"icon-[tabler--photo] size-5\"></span>" }'>{__("Photos")}</option>
  {if $system['geolocation_enabled']}
    <option value="map" data-select-option='{ "icon": "<span class=\"icon-[tabler--map-pin] size-5\"></span>" }'>{__("Maps")}</option>
  {/if}
  {if $system['rich_text_posts_enabled']}
    <option value="rich_text" data-select-option='{ "icon": "<span class=\"icon-[tabler--notes] size-5\"></span>" }'>{__("Write-ups")}</option>
  {/if}
  {if $system['blogs_enabled']}
    <option value="article" data-select-option='{ "icon": "<span class=\"icon-[tabler--article] size-5\"></span>" }'>{__("Blogs")}</option>
  {/if}
  {if $system['market_enabled'] && $_get != "posts_page" && $_get != "posts_group" && $_get != "posts_event"}
    <option value="product" data-select-option='{ "icon": "<span class=\"icon-[tabler--shopping-bag] size-5\"></span>" }'>{__("Products")}</option>
  {/if}
  {if $system['funding_enabled'] && $_get != "posts_page" && $_get != "posts_group" && $_get != "posts_event"}
    <option value="funding" data-select-option='{ "icon": "<span class=\"icon-[tabler--coin] size-5\"></span>" }'>{__("Funding")}</option>
  {/if}
  {if $system['offers_enabled']}
    <option value="offer" data-select-option='{ "icon": "<span class=\"icon-[tabler--discount-2] size-5\"></span>" }'>{__("Offers")}</option>
  {/if}
  {if $system['jobs_enabled']}
    <option value="job" data-select-option='{ "icon": "<span class=\"icon-[tabler--briefcase] size-5\"></span>" }'>{__("Jobs")}</option>
  {/if}
  {if $system['courses_enabled']}
    <option value="course" data-select-option='{ "icon": "<span class=\"icon-[tabler--school] size-5\"></span>" }'>{__("Courses")}</option>
  {/if}
  {if $system['polls_enabled']}
    <option value="poll" data-select-option='{ "icon": "<span class=\"icon-[tabler--chart-bar] size-5\"></span>" }'>{__("Polls")}</option>
  {/if}
  {if $system['reels_enabled']}
    <option value="reel" data-select-option='{ "icon": "<span class=\"icon-[tabler--movie] size-5\"></span>" }'>{__("Reels")}</option>
  {/if}
  {if $system['videos_enabled']}
    <option value="video" data-select-option='{ "icon": "<span class=\"icon-[tabler--video] size-5\"></span>" }'>{__("Videos")}</option>
  {/if}
  {if $system['audio_enabled']}
    <option value="audio" data-select-option='{ "icon": "<span class=\"icon-[tabler--headphones] size-5\"></span>" }'>{__("Audios")}</option>
  {/if}
  {if $system['file_enabled']}
    <option value="file" data-select-option='{ "icon": "<span class=\"icon-[tabler--file] size-5\"></span>" }'>{__("Files")}</option>
  {/if}
  {if $system['merits_enabled']}
    <option value="merit" data-select-option='{ "icon": "<span class=\"icon-[tabler--award] size-5\"></span>" }'>{__("Merits")}</option>
  {/if}
</select>
<!-- posts filter -->
