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
				<div class="text-md">
					<h5 class="headline-font m-0">
						{__("Oops! Page Not Be Found")}
					</h5>
				</div>
				
				<div class="mt-2 text-muted">
					{$message}
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