{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <!-- right panel -->
    <div class="col-lg-12 w-100">
		{if $view == "movie"}
			<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
				<div class="d-flex align-items-center gap-3 position-relative mw-0">
					<a href="{$system['system_url']}/movies" class="btn border-0 p-0 rounded-circle lh-1 flex-0">
						<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.99996 16.9998L4 11.9997L9 6.99976" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 12H20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg>
					</a>
					<span class="headline-font fw-semibold side_widget_title p-0 flex-1 text-truncate mw-0">{$movie['title']}</span>
				</div>
			</div>
			
			<div class="x_adslist rounded-0">
				{if $movie['can_watch']}
					<div class="ratio ratio-16x9">
						{if $movie['source_type'] == "youtube"}
							<iframe width="560" height="315" src="https://www.youtube.com/embed/{get_youtube_id($movie['source'], false)}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						{elseif $movie['source_type'] == "vimeo"}
							<iframe width="560" height="315" src="https://player.vimeo.com/video/{get_vimeo_id($movie['source'])}" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
						{elseif $movie['source_type'] == "link"}
							<div>
								<video class="js_video-plyr w-100" id="video-{$movie['movie_id']}" playsinline controls preload="false">
									<source src="{$movie['source']}" type="video/mp4">
									<source src="{$movie['source']}" type="video/webm">
								</video>
							</div>
						{elseif $movie['source_type'] == "uploaded"}
							<div>
								<video class="js_video-plyr w-100" id="video-{$movie['movie_id']}" playsinline controls preload="false">
									<source src="{$system['system_uploads']}/{$movie['source']}" type="video/mp4">
									<source src="{$system['system_uploads']}/{$movie['source']}" type="video/webm">
								</video>
							</div>
						{/if}
					</div>
				{else}
					<!-- need payment -->
					<div class="p-3">
						<div class="text-muted text-center py-5">
							<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="{if $paid_image}text-white{else}text-success text-opacity-75{/if}"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.78894 3.38546C7.87779 3.52092 7.77748 3.75186 7.57686 4.21374C7.49965 4.39151 7.42959 4.57312 7.36705 4.75819C7.29287 4.9777 7.25578 5.08746 7.17738 5.14373C7.09897 5.19999 6.99012 5.19999 6.77242 5.19999H4.18138C3.64164 5.19999 3.2041 5.63651 3.2041 6.17499C3.2041 6.71346 3.64164 7.14998 4.18138 7.14998L15.9776 7.14998C16.8093 7.13732 18.6295 7.14275 19.2563 7.26578C20.1631 7.3874 20.9639 7.65257 21.6051 8.29227C22.2463 8.93197 22.512 9.73091 22.6339 10.6355C22.7501 11.4972 22.75 12.5859 22.75 13.9062V15.9937C22.75 17.314 22.7501 18.4027 22.6339 19.2644C22.512 20.169 22.2463 20.9679 21.6051 21.6076C20.9639 22.2473 20.1631 22.5125 19.2563 22.6341C18.3927 22.75 17.3014 22.75 15.978 22.7499H9.97398C8.19196 22.7499 6.75559 22.75 5.6259 22.5984C4.45303 22.4411 3.4655 22.1046 2.68119 21.3221C1.89687 20.5396 1.55952 19.5543 1.40184 18.3842C1.24996 17.2572 1.24998 15.8241 1.25 14.0463V6.175C1.25 4.55957 2.56262 3.25001 4.18182 3.25001L6.99624 3.25C7.46547 3.25 7.70009 3.25 7.78894 3.38546ZM17.5 12.9998C18.6046 12.9998 19.5 13.8952 19.5 14.9998C19.5 16.1043 18.6046 16.9998 17.5 16.9998C16.3954 16.9998 15.5 16.1043 15.5 14.9998C15.5 13.8952 16.3954 12.9998 17.5 12.9998Z" fill="currentColor"></path><path d="M19.4557 6.03151C19.563 6.0463 19.6555 5.95355 19.6339 5.84742C19.1001 3.22413 16.7803 1.25 13.9994 1.25C11.3264 1.25 9.07932 3.07399 8.43503 5.54525C8.38746 5.72772 8.52962 5.90006 8.7182 5.90006L15.9679 5.90006C16.3968 5.89365 17.0712 5.89192 17.7232 5.90742C18.3197 5.92161 19.0159 5.95164 19.4557 6.03151Z" fill="currentColor"></path></svg>
							<div class="text-md mt-4">
								<h5 class="headline-font m-0">
									{__("PAID CONTENT")}
								</h5>
							</div>
						
							<div class="mt-3">
								<button class="btn btn-main" data-toggle="modal" data-url="#payment" data-options='{ "handle": "movies", "id": {$movie['movie_id']}, "price": {$movie['price']}, "vat": "{get_payment_vat_value($movie['price'])}", "fees": "{get_payment_fees_value($movie['price'])}", "total": "{get_payment_total_value($movie['price'])}", "total_printed": "{get_payment_total_value($movie['price'], true)}" }'>
									{__("PAY")} {print_money($movie['price']|number_format:2)} {__("TO WATCH FOR")} {$movie['available_for']} {__("DAYS")}
								</button>
							</div>
						</div>
					</div>
					<!-- need payment -->
				{/if}
			</div>
			
			<div class="p-3 pb-4">
				<div class="row">
					<div class="col-3 col-sm-2">
						<div class="movie-card-top position-relative">
							<div class="x_adslist w-100 movie-picture rounded-3" style="background-image:url({$movie['poster']});"></div>
						</div>
					</div>
					<div class="col-9 col-sm-10">
						<div class="text-muted fw-semibold text-uppercase small">
							{if $movie['release_year']}
								<span>{$movie['release_year']}</span>
							{/if}
							{if $movie['duration']}
								{if $movie['release_year']}<span class="fw-bold mx-1">·</span>{/if}
								<span>{$movie['duration']} {__("minutes")}</span>
							{/if}
						</div>
						<h1 class="headline-font fw-semibold mt-1">{$movie['title']}</h1>
						<div class="blog-text">
							{$movie['description']}
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-12">
						<ul class="list-unstyled mt-3">
							{if $movie['genres_list']}
								<li class="d-md-table-row pt-2">
									<span class="d-block d-md-table-cell align-top pe-4 text-muted fw-medium">{__("Genres")}</span>
									<span class="d-block d-md-table-cell align-top">
										{foreach $movie['genres_list'] as $_genre}
											<a href="{$system['system_url']}/movies/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">
												{__($_genre['genre_name'])}
											</a>
										{/foreach}
									</span>
								</li>
							{/if}
							{if {$movie['stars']}}
								<li class="d-md-table-row pt-2">
									<span class="d-block d-md-table-cell align-top pe-4 text-muted fw-medium">{__("Stars")}</span>
									<span class="d-block d-md-table-cell align-top">
										{foreach explode(',', $movie['stars']) as $_star}
											{$_star}{if !$_star@last}, {/if}
										{/foreach}
									</span>
								</li>
							{/if}
							{if $movie['imdb_url']}
								<li class="d-md-table-row pt-2">
									<span class="d-block d-md-table-cell align-top pe-4 text-muted fw-medium">{__("IMDB")}</span>
									<span class="d-block d-md-table-cell align-top">
										<a href="{$movie['imdb_url']}" target="_blank">{$movie['imdb_url']}</a>
									</span>
								</li>
							{/if}
							<li class="d-md-table-row pt-2">
								<span class="d-block d-md-table-cell align-top pe-4 text-muted fw-medium">{__("Views")}</span>
								<span class="d-block d-md-table-cell align-top">
									{$movie['views']}
								</span>
							</li>
						</ul>
					</div>
				</div>
			</div>

		{else}
			
			<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
				<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
					<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Movies")}</span>
				</div>
			</div>
			
			<div class="pt-3 pb-2 px-2 mx-1">
				<form class="js_search-form" data-handle="movies">
					<div class="position-relative">
						<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search for movies")}'>
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
					</div>
				</form>
			</div>
			
			<!-- categories -->
			<div class="pb-3 pt-2">
				<div class="overflow-hidden x_page_cats x_page_scroll d-flex align-items-start position-relative">
					<ul class="px-3 d-flex gap-2 align-items-center overflow-x-auto pb-3 scrolll">
						{if $view == "genre"}
							<li>
								<a class="btn btn-sm border-0 ps-0 pe-1" href="{$system['system_url']}/movies">
									<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.99996 16.9998L4 11.9997L9 6.99976" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 12H20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg>
									{__("All")}
								</a>
							</li>
						{/if}
						{foreach $genres as $_genre}
							<li {if $view == "genre" && $genre['genre_id'] == $_genre['genre_id']}class="position-relative main main_bg_half" {/if}>
								<a class="btn btn-sm" href="{$system['system_url']}/movies/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">
									{__($_genre['genre_name'])}
								</a>
							</li>
						{/foreach}
					</ul>
					<div class="d-flex align-items-center justify-content-between position-absolute w-100 h-100 pe-none scroll-btns">
						<div class="pe-auto">
							<button class="btn rounded-circle p-1 bg-black text-white mx-2 scroll-left-btn">
								<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15 6L9 12.0001L15 18" stroke="currentColor" stroke-width="2" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
							</button>
						</div>
						<div class="pe-auto">
							<button class="btn rounded-circle p-1 bg-black text-white mx-2 scroll-right-btn">
								<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.00005 6L15 12L9 18" stroke="currentColor" stroke-width="2" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
							</button>
						</div>
					</div>
				</div>
			</div>
			<!-- categories -->
			
			{include file='_ads.tpl'}

			{if $view == "search"}
				<div class="text-muted px-3 pb-3">
					<!-- results counter -->
						<span class="fw-medium">{$total}</span> {__("results were found for the search for")} "<strong class="main fw-medium">{htmlentities($query, ENT_QUOTES, 'utf-8')}</strong>"
					<!-- results counter -->
				</div>
			{/if}

			<div class="px-3 pb-3">
				{if $movies}
					<ul class="row">
						{foreach $movies as $_movie}
							<li class="col-6 col-md-4 col-lg-3 mb-4">
								<div class="movie-card">
									<a href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" class="movie-card-top position-relative d-block">
										<div class="x_adslist w-100 movie-picture rounded-3" style="background-image:url('{$_movie['poster']}');"></div>
										<div class="position-absolute m-2 d-inline-flex rounded-2 fw-medium small text-white boosted-icon bottom-0 bg-dark">
											{if $_movie['genres_list'][0]}{__($_movie['genres_list'][0]['genre_name'])}{/if}{if $_movie['genres_list'][1]}, {__($_movie['genres_list'][1]['genre_name'])}{/if}
										</div>
									</a>
									<div class="movie-card-bottom mt-1">
										<div class="text-truncate">
											<a href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" class="movie-title text-truncate fw-semibold" title="{$_movie['title']}">
												{$_movie['title']} {if $_movie['is_paid']}<span class="badge rounded-pill bg-success bg-opacity-75">{__("Paid")}</span>{/if}
											</a>
										</div>
										<div class="movie-year text-truncate small">{if $_movie['release_year']}{$_movie['release_year']}{else}{__("N/A")}{/if}</div>
									</div>
								</div>
							</li>
						{/foreach}
					</ul>

					{$pager}
				{else}
					{include file='_no_data.tpl'}
				{/if}
			</div>

		{/if}
    </div>
    <!-- right panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}