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
		<div class="p-3">
			<h1 class="headline-font fw-semibold">{__($static_page['page_title'])}</h1>
			
			{if $static_pages}
				<div class="mb-3 d-flex flex-wrap gap-3">
					{foreach $static_pages as $static_page}
						{if $static_page['page_in_footer']}
							<a {if !$static_page@first}class="fw-medium" {/if} href="{$static_page['url']}">
								{__($static_page['page_title'])}
							</a>
						{/if}
					{/foreach}
				</div>
			{/if}
			
			<div class="static-page-content text-with-list">
				{$static_page['page_text']}
			</div>
		</div>
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}