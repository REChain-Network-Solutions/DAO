{if $featured}
  <!-- featured -->
  <div class="js_hero-slider relative isolate" data-speed="7000" role="region" aria-label='{__("Featured")}' tabindex="0">

    <div class="overflow-hidden">
      <div class="js_hero-slider-track relative aspect-[4/3] w-full cursor-grab touch-pan-y select-none transition-transform duration-300 ease-out sm:aspect-video lg:aspect-[2.351/1]">
        {foreach $featured as $_movie}
          <div class="group/slide absolute inset-y-0 start-full z-0 w-[9.5%] opacity-0 transition-all duration-700 ease-out data-[pos=active]:start-0 data-[pos=active]:z-30 data-[pos=active]:w-full data-[pos=active]:opacity-100 data-[pos=out]:-start-[100%] data-[pos=out]:w-full lg:data-[pos=active]:w-[82.5%] lg:data-[pos=stack1]:inset-y-[7%] lg:data-[pos=stack1]:start-[80%] lg:data-[pos=stack1]:z-20 lg:data-[pos=stack1]:w-[13%] lg:data-[pos=stack1]:opacity-100 lg:data-[pos=stack2]:inset-y-[13%] lg:data-[pos=stack2]:start-[90.5%] lg:data-[pos=stack2]:z-10 lg:data-[pos=stack2]:w-[9.5%] lg:data-[pos=stack2]:opacity-85 lg:data-[pos=out]:-start-[85%] lg:data-[pos=out]:w-[82.5%]" data-pos="{if $_movie@index == 0}active{elseif $_movie@index == 1}stack1{elseif $_movie@index == 2}stack2{else}off{/if}">
            <article class="absolute inset-0 overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-300 shadow-xl">
              <img class="absolute inset-0 size-full object-cover" src="{$_movie['poster']}" alt="" draggable="false" loading="lazy">
              <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/85 via-black/15 to-transparent opacity-0 transition-opacity duration-500 group-data-[pos=active]/slide:opacity-100" aria-hidden="true"></span>

              <div class="absolute inset-x-5 top-5 flex flex-wrap items-center gap-2 opacity-0 transition-opacity duration-500 group-data-[pos=active]/slide:opacity-100 sm:inset-x-6 sm:top-6 sm:gap-2.5 lg:inset-x-7 lg:top-7">
                {if $_movie['duration_text']}
                  <span class="rounded-2xl bg-black/30 px-3 py-1.5 text-xs font-medium text-white backdrop-blur-md sm:px-4 sm:py-2 sm:text-sm">{$_movie['duration_text']}</span>
                {/if}
                {foreach $_movie['genres_list'] as $_genre}
                  {if $_genre@iteration <= 2}
                    <span class="rounded-2xl bg-black/30 px-3 py-1.5 text-xs font-medium text-white backdrop-blur-md sm:px-4 sm:py-2 sm:text-sm">{__($_genre['genre_name'])}</span>
                  {/if}
                {/foreach}
                {if $_movie['release_year']}
                  <span class="rounded-2xl bg-black/30 px-3 py-1.5 text-xs font-medium text-white backdrop-blur-md sm:px-4 sm:py-2 sm:text-sm">{$_movie['release_year']}</span>
                {/if}
                {if $_movie['is_paid']}
                  <span class="flex items-center gap-1.5 rounded-2xl bg-error px-3 py-1.5 text-xs font-medium text-error-content sm:px-4 sm:py-2 sm:text-sm">
                    <span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>
                    {__("Paid")}
                  </span>
                {/if}
              </div>

              <div class="absolute inset-x-5 bottom-5 flex items-center gap-3.5 opacity-0 transition-opacity duration-500 group-data-[pos=active]/slide:opacity-100 sm:inset-x-6 sm:bottom-6 sm:gap-4 lg:inset-x-7 lg:bottom-7">
                <a class="flex size-12 shrink-0 items-center justify-center rounded-full bg-white/20 text-white! backdrop-blur-sm transition hover:bg-white/25 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white sm:size-14 lg:size-16" href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" aria-label="{$_movie['title']}">
                  <span class="icon-[tabler--player-play-filled] size-5 lg:size-6" aria-hidden="true"></span>
                </a>
                <div class="min-w-0 flex-1">
                  <a class="block truncate text-lg font-bold text-white! hover:text-white/80! sm:text-xl lg:text-2xl" href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" title="{$_movie['title']}">{$_movie['title']}</a>
                  <span class="mt-0.5 flex items-center gap-2 text-sm font-bold text-white lg:text-base">
                    {__("Watch now")}
                    <span class="font-normal text-white/60">{$_movie['views_text']} {__("Views")}</span>
                  </span>
                </div>
              </div>
            </article>
          </div>
        {/foreach}
      </div>
    </div>

    <div class="js_hero-slider-dots absolute end-2 top-2 z-40 flex items-center gap-2 max-lg:rounded-full max-lg:bg-black/35 max-lg:px-2.5 max-lg:py-2 max-lg:backdrop-blur-md" data-label='{__("Slide")}'></div>

  </div>
  <!-- featured -->
{/if}
