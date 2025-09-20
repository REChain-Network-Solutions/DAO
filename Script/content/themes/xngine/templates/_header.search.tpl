<div class="search-wrapper">
	<form class="position-relative">
		<input id="search-input" type="text" class="form-control shadow-none rounded-pill" placeholder='{__("Search")}' autocomplete="off">
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" /></svg>
    <div id="search-results" class="dropdown-menu dropdown-widget dropdown-search js_dropdown-keepopen">
      <div class="dropdown-widget-header">
        <span class="title">{__("Search Results")}</span>
      </div>
      <div class="dropdown-widget-body">
        <div class="loader loader_small ptb10"></div>
      </div>
      <a class="dropdown-widget-footer" id="search-results-all" href="{$system['system_url']}/search/">{__("See All Results")}</a>
    </div>
    {if $user->_logged_in && $user->_data['search_log']}
      <div id="search-history" class="dropdown-menu dropdown-widget dropdown-search js_dropdown-keepopen">
        <div class="dropdown-widget-header">
          <span class="text-link float-end js_clear-searches">
            {__("Clear")}
          </span>
          <span class="title">{__("Recent Searches")}</span>
        </div>
        <div class="dropdown-widget-body">
          {include file='ajax.search.tpl' results=$user->_data['search_log']}
        </div>
        <a class="dropdown-widget-footer" id="search-results-all" href="{$system['system_url']}/search/">{__("Advanced Search")}</a>
      </div>
    {/if}
  </form>
</div>