{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "users"}
    {include file='__page_header.tpl' _title=__("Users") _text=__("Help friends know you better and show them what you have in common") _image="directory.svg"}
  {elseif $view == "posts"}
    {include file='__page_header.tpl' _title=__("Posts") _text=__("See what everyone’s up to and what’s on their minds") _image="directory.svg"}
  {elseif $view == "pages"}
    {include file='__page_header.tpl' _title=__("Pages") _text=__("Never miss a thing out! Keep in touch with your fans and customers") _image="directory.svg"}
  {elseif $view == "groups"}
    {include file='__page_header.tpl' _title=__("Groups") _text=__("Communicate and collaborate with the people who share your interests") _image="directory.svg"}
  {elseif $view == "events"}
    {include file='__page_header.tpl' _title=__("Events") _text=__("Members can organize community events for online and offline doings") _image="directory.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Directory") _text=__($system['system_description_directory']) _image="directory.svg"}
  {/if}
  <!-- page heading -->

  {if $view == ""}

    <div class="mt-6">
      {include file='__directory_nav.tpl' _variant="tile" _view=$view}
    </div>

  {else}

    <div class="mt-6 grid gap-6 lg:grid-cols-[15rem_minmax(0,1fr)] lg:items-start xl:grid-cols-[15rem_minmax(0,1fr)_18rem]">

      <!-- categories -->
      <aside class="lg:sticky lg:top-24">
        {include file='__directory_nav.tpl' _variant="rail" _view=$view}
      </aside>
      <!-- categories -->

      <!-- listing -->
      <div class="flex min-w-0 flex-col gap-4">
        <h2 class="flex items-center gap-2 text-lg font-semibold">
          {if $view == "users"}{__("Users")}{elseif $view == "posts"}{__("Posts")}{elseif $view == "pages"}{__("Pages")}{elseif $view == "groups"}{__("Groups")}{elseif $view == "events"}{__("Events")}{/if}
        </h2>
        {if $rows}
          {if $view == "posts"}
            <ul class="flex flex-col gap-5">
              {foreach $rows as $post}
                {include file='__feeds_post.tpl'}
              {/foreach}
            </ul>
          {else}
            <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2">
              {if $view == "users"}
                {foreach $rows as $_user}
                  {include file='__people_card.tpl' _connection=$_user["connection"]}
                {/foreach}
              {elseif $view == "pages"}
                {foreach $rows as $_page}
                  {include file='__pages_card.tpl'}
                {/foreach}
              {elseif $view == "groups"}
                {foreach $rows as $_group}
                  {include file='__groups_card.tpl'}
                {/foreach}
              {elseif $view == "events"}
                {foreach $rows as $_event}
                  {include file='__feeds_event.tpl' _tpl="box"}
                {/foreach}
              {/if}
            </ul>
          {/if}
          {if $pager}{$pager}{/if}
        {else}
          <div class="card border border-base-300 bg-base-100 shadow-none">
            {include file='_no_data.tpl'}
          </div>
        {/if}
      </div>
      <!-- listing -->

      <!-- aside -->
      <aside class="flex flex-col gap-6 lg:col-span-2 xl:sticky xl:top-24 xl:col-span-1">
        {include file='_ads_campaigns.tpl'}
        {include file='_ads.tpl'}
        {include file='_widget.tpl'}
      </aside>
      <!-- aside -->

    </div>

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
