<footer class="mini-footer mb-3 px-3">
	<div class="copyrights d-flex align-items-center justify-content-between">
		<span class="flex-0 text-muted">&copy; {date('Y')} {__($system['system_title'])}</span>
		<!-- language -->
		<div class="dropdown">
			<a href="javascript:void(0);" class="language-dropdown text-muted" data-bs-toggle="dropdown">
				<span>{$system['language']['title']}</span>
			</a>
			<div class="dropdown-menu dropdown-menu-end">
				<div class="js_scroller">
					{foreach $system['languages'] as $language}
						<a class="dropdown-item" href="?lang={$language['code']}">
							<img width="16" height="16" class="flex-0" src="{$language['flag']}">{$language['title']}
						</a>
					{/foreach}
				</div>
			</div>
		</div>
		<!-- language -->
	</div>
	<div class="d-flex align-items-center flex-wrap mt-1 links">
		{if $static_pages}
			{foreach $static_pages as $static_page}
				{if $static_page['page_in_footer']}
					<a href="{$static_page['url']}" class="text-muted">
						{__($static_page['page_title'])}
					</a>
				{/if}
			{/foreach}
		{/if}
		{if $system['contact_enabled']}
			<a href="{$system['system_url']}/contacts" class="text-muted">
				{__("Contact Us")}
			</a>
		{/if}
		{if $system['directory_enabled']}
			<a href="{$system['system_url']}/directory" class="text-muted">
				{__("Directory")}
			</a>
		{/if}
		{if $system['developers_apps_enabled'] || $system['developers_share_enabled']}
			<a href="{$system['system_url']}/developers{if !$system['developers_apps_enabled']}/share{/if}" class="text-muted">
				{__("Developers")}
			</a>
		{/if}
	</div>
</footer>