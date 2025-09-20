{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
@media (max-width: 520px) {
	html, body {
		overscroll-behavior: none;overflow-y: hidden;
	}
	.main-wrapper {
        padding: 0 0 50px;
    }
    .x_side_create, .logo-wrapper, .x_user_mobi_menu, body .search-wrapper-prnt {
        display: none !important;
    }
	.x_content_row>.col-lg-8 {
        min-height: calc(100dvh - 49px);
		min-height: calc(var(--vh, 1vh) * 100 - 49px);
    }
}
</style>

<!-- page content -->
<div class="row x_content_row overflow-hidden">
    <div class="col-lg-8">
		<div class="reels-wrapper position-relative bg-black w-100 h-100">
			{if $posts}
				<div class="reels-loader text-white bg-black position-absolute" data-offset="1">
					<div class="d-flex align-items-center justify-content-center flex-column gap-3 w-100 h-100">
						<svg width="38" height="38" viewBox="0 0 38 38" xmlns="http://www.w3.org/2000/svg"> <defs> <linearGradient x1="8.042%" y1="0%" x2="65.682%" y2="23.865%" id="a"> <stop stop-color="currentColor" stop-opacity="0" offset="0%"/> <stop stop-color="currentColor" stop-opacity=".631" offset="63.146%"/> <stop stop-color="currentColor" offset="100%"/> </linearGradient> </defs> <g fill="none" fill-rule="evenodd"> <g transform="translate(1 1)"> <path d="M36 18c0-9.94-8.06-18-18-18" id="Oval-2" stroke="url(#a)" stroke-width="2"> <animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="0.9s" repeatCount="indefinite" /> </path> <circle fill="currentColor" cx="36" cy="18" r="1"> <animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="0.9s" repeatCount="indefinite" /> </circle> </g> </g> </svg>
						{__("Loading")}...
					</div>
				</div>
				{foreach $posts as $post}
					{include file='__feeds_reel.tpl' _iteration=$post@iteration}
				{/foreach}
			{else}
				{include file='_no_data.tpl'}
			{/if}
		</div>
    </div>
    <div class="col-lg-4 d-none d-lg-block">
		
	</div>
</div>
<!-- page content -->

{include file='_footer.tpl'}

<script>
	var first_id = $('.reel-container').first().data('id');
	if (first_id) {
		var url = site_path + '/reels/' + first_id;
		window.history.pushState({ state: 'new' }, '', url);
	}
</script>
<script>
function setVHVariable() {
	var e = .01 * window.innerHeight;
	document.documentElement.style.setProperty("--vh", "".concat(e, "px"))
}
window.onload = setVHVariable;
window.onresize = setVHVariable;
</script>