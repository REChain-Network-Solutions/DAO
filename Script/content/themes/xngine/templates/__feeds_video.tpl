<div class="col-6 col-md-4 col-lg-3">
	<a class="pg_video position-relative w-100 h-100 d-block overflow-hidden x_adslist rounded-3 ratio ratio-1x1" href="{$system['system_url']}/{if $_is_reel}reels{else}posts{/if}/{$video['post_id']}">
		<video class="object-cover">
			{if empty($video['source_240p']) && empty($video['source_360p']) && empty($video['source_480p']) && empty($video['source_720p']) && empty($video['source_1080p']) && empty($video['source_1440p']) && empty($video['source_2160p'])}
				<source src="{$system['system_uploads']}/{$video['source']}" type="video/mp4">
			{/if}
			{if $video['source_240p']}
				<source src="{$system['system_uploads']}/{$video['source_240p']}" type="video/mp4" label="240p" res="240">
			{/if}
			{if $video['source_360p']}
				<source src="{$system['system_uploads']}/{$video['source_360p']}" type="video/mp4" label="360p" res="360">
			{/if}
			{if $video['source_480p']}
				<source src="{$system['system_uploads']}/{$video['source_480p']}" type="video/mp4" label="480p" res="480">
			{/if}
			{if $video['source_720p']}
				<source src="{$system['system_uploads']}/{$video['source_720p']}" type="video/mp4" label="720p" res="720">
			{/if}
			{if $video['source_1080p']}
				<source src="{$system['system_uploads']}/{$video['source_1080p']}" type="video/mp4" label="1080p" res="1080">
			{/if}
			{if $video['source_1440p']}
				<source src="{$system['system_uploads']}/{$video['source_1440p']}" type="video/mp4" label="1440p" res="1440">
			{/if}
			{if $video['source_2160p']}
				<source src="{$system['system_uploads']}/{$video['source_2160p']}" type="video/mp4" label="2160p" res="2160">
			{/if}
		</video>
		<div class="play-button text-white bg-black d-flex align-items-center justify-content-center rounded-circle">
			<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.9405 6.337C15.5735 7.26468 16.8567 7.99369 17.7709 8.66148C18.6913 9.33386 19.3721 10.0366 19.6159 10.9632C19.7947 11.6426 19.7947 12.3574 19.6159 13.0368C19.3721 13.9634 18.6913 14.6661 17.7709 15.3385C16.8567 16.0063 15.5735 16.7353 13.9406 17.663L13.9406 17.663C12.3632 18.5591 11.033 19.3148 10.0232 19.7444C9.0053 20.1773 8.07729 20.3968 7.17536 20.1412C6.51252 19.9533 5.90941 19.5968 5.42356 19.1066C4.76419 18.4414 4.49951 17.5219 4.37429 16.4154C4.24998 15.3169 4.24999 13.879 4.25 12.0501V12.0501V11.9499V11.9499C4.24999 10.121 4.24998 8.68309 4.37429 7.58464C4.49951 6.4781 4.76419 5.55861 5.42356 4.89335C5.90941 4.40317 6.51252 4.04666 7.17536 3.85883C8.07729 3.60325 9.0053 3.82269 10.0232 4.25565C11.033 4.68516 12.3632 5.44084 13.9405 6.337Z" fill="currentColor"/></svg>			
		</div>
	</a>
</div>