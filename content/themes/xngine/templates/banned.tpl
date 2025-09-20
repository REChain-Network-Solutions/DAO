{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-12 w-100">
		<div class="notfound-wrapper h-100 d-flex align-items-center justify-content-center p-3">
			<div class="notfound text-center mx-auto">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="60" height="60" class="d-block mb-4 mx-auto text-danger"><path fill="currentColor" d="M12,0A12,12,0,1,0,24,12,12.013,12.013,0,0,0,12,0Zm0,2a9.949,9.949,0,0,1,6.324,2.262L4.262,18.324A9.992,9.992,0,0,1,12,2Zm0,20a9.949,9.949,0,0,1-6.324-2.262L19.738,5.676A9.992,9.992,0,0,1,12,22Z"/></svg>

				<div class="text-md">
					<h2 class="headline-font m-0">
						{__("Banned!")}
					</h2>
				</div>
				
				<div class="mt-2 text-muted">
					reyey erre er {$message}
				</div>
			
				<div class="mt-5">
					<a class="btn btn-primary" href="{$system['system_url']}">{__("Back to homepage")}</a>
				</div>
			</div>
		</div>
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}