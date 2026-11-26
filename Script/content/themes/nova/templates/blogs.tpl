{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  {if $view == "" || $view == "category" || $view == "manage" || $view == "search"}

    {if $view == ""}
      <!-- Schema.org structured data for blogs listing page -->
      <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "CollectionPage",
          "name": "{__("Blogs")|escape:'html'}",
          "description": "{__($system['system_description_blogs'])|escape:'html'}",
          "url": "{$system['system_url']}/blogs",
          "publisher": {
            "@type": "Organization",
            "name": "{$system['system_title']|escape:'html'}",
            "url": "{$system['system_url']}"
          },
          "mainEntity": {
            "@type": "ItemList",
            "numberOfItems": "{if $rows}{$rows|count}{else}0{/if}"
          }
        }
      </script>
      <!-- Schema.org structured data for blogs listing page -->
    {elseif $view == "category"}
      <!-- Schema.org structured data for blog category page -->
      <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "CollectionPage",
          "name": "{__($current_category['category_name'])|escape:'html'}",
          "description": "{if $current_category['category_description']}{__($current_category['category_description'])|escape:'html'}{else}{__($current_category['category_name'])|escape:'html'} {__("blogs")|escape:'html'}{/if}",
          "url": "{$system['system_url']}/blogs/category/{$current_category['category_id']}/{$current_category['category_url']}",
          "publisher": {
            "@type": "Organization",
            "name": "{$system['system_title']|escape:'html'}",
            "url": "{$system['system_url']}"
          },
          "mainEntity": {
            "@type": "ItemList",
            "numberOfItems": "{if $rows}{$rows|count}{else}0{/if}"
          }
        }
      </script>
      <!-- Schema.org structured data for blog category page -->
    {/if}

    {include file='__listing_page.tpl' _module="blogs" _image="blogs.svg" _title=__("Blogs") _text=__($system['system_description_blogs']) _search_placeholder=__("Search for blogs") _create_enabled=true _create_href="`$system['system_url']`/blogs/new" _create_label=__("Create New Blog") _my_label=__("My Blogs") _my_icon="icon-[tabler--article]" _card="__feeds_blog.tpl" _promoted=$promoted_blogs _promoted_title=__("Promoted Blogs") _empty_icon="icon-[tabler--article]" _rss_href=$rss_url|default:''}

  {elseif $view == "blog"}

    <div class="grid gap-6 lg:grid-cols-[minmax(0,1fr)_16rem] lg:items-start xl:grid-cols-[minmax(0,1fr)_18rem] xl:gap-8">
      <div class="flex min-w-0 flex-col gap-6">
        {if $blog['needs_payment']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price'] discounted_price=$blog['post_price_discounted'] paid_text=$blog['paid_text'] paid_image=$blog['paid_image']}
          </div>
        {elseif $blog['needs_subscription']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_subscription.tpl' node_type=$blog['needs_subscription_type'] node_id=$blog['needs_subscription_id'] price=$blog['needs_subscription_price'] discount_enabled=$blog['needs_subscription_discount_enabled'] discount_percent=$blog['needs_subscription_discount_percent'] subscriptions_image=$blog['subscriptions_image']}
          </div>
        {elseif $blog['needs_pro_package']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_pro_package.tpl' _manage = true}
          </div>
        {elseif $blog['needs_age_verification']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_age_verification.tpl'}
          </div>
        {else}
          {$_blog_pending = (($blog['is_pending']) OR ($blog['in_group'] && !$blog['group_approved']) OR ($blog['in_event'] && !$blog['event_approved']))}
          <article class="blog post min-w-0" data-id="{$blog['post_id']}">
            {if $blog['blog']['cover']}
              <div class="aspect-[2/1] max-h-[26rem] overflow-hidden rounded-2xl bg-base-200 sm:aspect-[21/9] sm:rounded-3xl">
                <img class="size-full object-cover" src="{$blog['blog']['parsed_cover']}" alt="" fetchpriority="high">
              </div>
            {/if}

            <div class="relative grid min-w-0 gap-5 rounded-2xl bg-base-100 px-4 py-5 sm:gap-6 sm:rounded-3xl sm:p-6 xl:grid-cols-[2.75rem_minmax(0,1fr)] xl:gap-x-6{if $blog['blog']['cover']} mx-2 -mt-8 sm:mx-4 sm:-mt-14 xl:mx-5 xl:-mt-20{/if}">
              <!-- article heading -->
              <div class="mx-auto flex w-full min-w-0 max-w-[80ch] flex-col gap-4 border-b border-base-300 pb-5 xl:col-start-2">
                <div class="flex flex-wrap items-center justify-between gap-3">
                  <nav class="breadcrumbs min-w-0 py-0 text-xs" aria-label="{__("Breadcrumb")}">
                    <ol class="min-w-0 flex-wrap gap-y-1">
                      <li><a class="text-base-content/60! hover:text-primary!" href="{$system['system_url']}/blogs">{__("Blogs")}</a></li>
                      {if $blog['blog']['category_id']}
                        <li class="breadcrumbs-separator rtl:rotate-180" aria-hidden="true"><span class="icon-[tabler--chevron-right] size-3"></span></li>
                        <li><a class="font-medium text-primary! hover:underline" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">{__($blog['blog']['category_name'])}</a></li>
                      {/if}
                    </ol>
                  </nav>
                  {if $_blog_pending}
                    <span class="badge badge-soft badge-warning badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>
                      {__("Pending Post")}
                    </span>
                  {/if}
                </div>

                <h1 class="break-words text-2xl font-bold leading-tight tracking-tight sm:text-[1.75rem] xl:text-[2rem]">{$blog['blog']['title']}</h1>

                <div class="flex min-w-0 items-center gap-3">
                  <a class="shrink-0" href="{$blog['post_author_url']}">
                    <img class="size-11 rounded-full object-cover" src="{$blog['post_author_picture']}" alt="">
                  </a>
                  <div class="min-w-0">
                    <div class="flex items-center gap-1 text-sm font-semibold">
                      <span class="js_user-popover min-w-0 truncate" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}" title="{$blog['post_author_name']}">
                        <a class="text-base-content! hover:text-primary!" href="{$blog['post_author_url']}">{$blog['post_author_name']}</a>
                      </span>
                      {if $blog['post_author_verified']}
                        {include file='__badge.tpl' _badge="verified" _badge_type=$blog['user_type']}
                      {/if}
                      {if $blog['user_subscribed']}
                        {include file='__badge.tpl' _badge="pro" _badge_package=$blog['package_name']}
                      {/if}
                    </div>
                    <div class="mt-0.5 flex flex-wrap items-center gap-x-2 gap-y-1 text-xs text-base-content/60">
                      <time datetime="{$blog['time']|date_format:'%Y-%m-%dT%H:%M:%S'}" title="{$blog['time']|date_format:$system['system_datetime_format']}">{$blog['time']|date_format:$system['system_date_format']}</time>
                      <span class="text-base-content/30" aria-hidden="true">·</span>
                      <span class="inline-flex items-center gap-1">
                        <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>
                        {$reading_time} {__("min read")}
                      </span>
                      {if $blog['still_scheduled']}
                        <span class="badge badge-soft badge-warning badge-sm gap-1 rounded-full">
                          <span class="icon-[tabler--calendar-time] size-3.5" aria-hidden="true"></span>
                          {__("Scheduled")}
                        </span>
                      {/if}
                      {if $blog['for_subscriptions']}
                        <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Subscriptions")}</span>
                      {/if}
                      {if $blog['is_paid']}
                        <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Paid")}</span>
                      {/if}
                    </div>
                  </div>
                </div>

                {if $blog['is_collaborative']}
                  <div class="flex flex-wrap items-center gap-2 text-sm text-base-content/60">
                    <span>{__("Collaborated with")}</span>
                    {foreach $blog['collaborative_users'] as $_collaborator}
                      <span class="js_user-popover" data-type="user" data-uid="{$_collaborator['user_id']}">
                        <a class="badge h-8 gap-2 rounded-full border-base-300 bg-base-100 ps-1 pe-3 text-sm font-medium text-base-content/80! transition-colors hover:border-primary/40 hover:bg-primary/5 hover:text-primary!" href="{$system['system_url']}/{$_collaborator['user_name']}">
                          <img class="size-6 rounded-full object-cover" src="{$_collaborator['user_picture']}" alt="">
                          {$_collaborator['user_fullname']}
                        </a>
                      </span>
                    {/foreach}
                  </div>
                {/if}
              </div>
              <!-- article heading -->

              <!-- article actions -->
              <div class="flex flex-wrap items-center gap-2 xl:sticky xl:top-24 xl:col-start-1 xl:row-start-2 xl:flex-col xl:items-center xl:self-start">
                {if $user->_logged_in}
                  {include file='__save_button.tpl' _post_id=$blog['post_id'] _saved=$blog['i_save']}
                  {if $blog['privacy'] == "public"}
                    <button type="button" class="js_modal heroui button button--outline button--sm button--icon-only rounded-full size-9 border-base-300 text-base-content" data-url="posts/share.php?do=create&post_id={$blog['post_id']}">
                      <i class="icon-[tabler--share-3] size-4" aria-hidden="true"></i>
                      <span class="sr-only">{__("Share")}</span>
                    </button>
                  {/if}
                {/if}
                {if $blog['can_edit_post']}
                  <a class="heroui button button--outline button--sm button--icon-only rounded-full size-9 border-base-300 text-base-content" href="{$system['system_url']}/blogs/edit/{$blog['post_id']}" title="{__("Edit")}">
                    <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                    <span class="sr-only">{__("Edit")}</span>
                  </a>
                {/if}
                <div class="ms-auto flex items-center gap-4 text-center xl:ms-0 xl:mt-4 xl:flex-col">
                  {if !$blog['comments_disabled']}
                    <a class="block rounded-field text-base-content! hover:text-primary! focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-primary" href="#blog-comments">
                      <div class="text-sm font-semibold">{$blog['comments_formatted']}</div>
                      <div class="mt-0.5 text-xs text-base-content/50">{__("Comments")}</div>
                    </a>
                  {/if}
                  <div>
                    <div class="text-sm font-semibold">{$blog['views_formatted']}</div>
                    <div class="mt-0.5 text-xs text-base-content/50">{__("Views")}</div>
                  </div>
                </div>
              </div>
              <!-- article actions -->

              <div class="mx-auto flex w-full min-w-0 max-w-[80ch] flex-col gap-5 sm:gap-6 xl:col-start-2 xl:row-start-2">
                <!-- article body -->
                <div class="blog-text text-with-list min-w-0 break-words text-[0.9375rem] leading-7 text-base-content/85 [&_a]:text-primary [&_a]:underline [&_blockquote]:my-5 [&_blockquote]:border-s-4 [&_blockquote]:border-primary/40 [&_blockquote]:ps-5 [&_blockquote]:italic [&_h1]:mb-3 [&_h1]:mt-6 [&_h1]:text-2xl [&_h1]:font-bold [&_h2]:mb-3 [&_h2]:mt-6 [&_h2]:text-xl [&_h2]:font-bold [&_h3]:mb-2 [&_h3]:mt-5 [&_h3]:text-lg [&_h3]:font-semibold [&_img]:my-5 [&_img]:h-auto [&_img]:max-w-full [&_img]:rounded-2xl [&_ol]:mb-4 [&_ol]:list-decimal [&_ol]:ps-6 [&_p]:mb-4 [&_pre]:my-5 [&_pre]:overflow-x-auto [&_pre]:rounded-xl [&_pre]:bg-base-200 [&_pre]:p-4 [&_pre]:text-sm [&_ul]:mb-4 [&_ul]:list-disc [&_ul]:ps-6" dir="auto">
                  {$blog['blog']['parsed_text']}
                </div>
                <!-- article body -->

                {if $blog['blog']['parsed_tags']}
                  <div class="flex flex-wrap gap-2">
                    {foreach $blog['blog']['parsed_tags'] as $tag}
                      <a class="badge badge-soft rounded-full text-base-content! hover:bg-base-300" href="{$system['system_url']}/search/hashtag/{$tag}">#{__($tag)}</a>
                    {/foreach}
                  </div>
                {/if}

                {if $blog['blog']['references']}
                  <section class="rounded-xl border border-base-300 bg-base-200/40 p-4" aria-labelledby="blog-references-title">
                    <h3 class="mb-3 flex items-center gap-2 text-sm font-semibold" id="blog-references-title">
                      <span class="icon-[tabler--book] size-4.5 text-base-content/60" aria-hidden="true"></span>
                      {__("References")}
                    </h3>
                    <ol class="flex list-decimal flex-col gap-1.5 ps-5 text-sm">
                      {foreach $blog['blog']['references'] as $reference}
                        <li>
                          <a class="inline-flex items-center gap-1 hover:underline" href="{$reference['link']}" target="_blank" rel="noopener noreferrer">
                            {$reference['title']}
                            <span class="icon-[tabler--external-link] size-3.5" aria-hidden="true"></span>
                          </a>
                        </li>
                      {/foreach}
                    </ol>
                  </section>
                {/if}

                <div>
                  <!-- reactions stats -->
                  <div class="js_post-reactions-stats">
                    {if $blog['reactions_total_count'] > 0}
                      <div class="js_modal reactions-stats flex w-fit cursor-pointer items-center pb-3 text-sm text-base-content/60 hover:text-base-content" data-url="posts/who_reacts.php?post_id={$blog['post_id']}">
                        {foreach $blog['reactions'] as $reaction_type => $reaction_count}
                          {if $reaction_count > 0}
                            <div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-0.5 first:ms-0" style="z-index: {10 - $reaction_count@iteration};">
                              <div class="inline-emoji no_animation inline-flex size-4.5">
                                {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                              </div>
                            </div>
                          {/if}
                        {/foreach}
                        <span class="ms-1.5">{$blog['reactions_total_count_formatted']}</span>
                      </div>
                    {/if}
                  </div>
                  <!-- reactions stats -->

                  {if $user->_logged_in}
                    <!-- post actions -->
                    <div class="post-actions flex items-center border-t border-base-300 py-2">
                      <div class="action-btn unselectable reactions-wrapper flex min-h-10 flex-1 cursor-pointer items-center justify-center rounded-field px-2 text-sm font-semibold transition-colors hover:bg-base-200 {if $blog['i_react']}js_unreact-post{/if}" data-reaction="{$blog['i_reaction']}">
                        <div class="reaction-btn flex items-center justify-center">
                          {if !$blog['i_react']}
                            <div class="reaction-btn-icon inline-flex">
                              <span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span>
                            </div>
                            <span class="reaction-btn-name ms-2 hidden sm:inline">{__("React")}</span>
                          {else}
                            <div class="reaction-btn-icon inline-flex">
                              <div class="inline-emoji no_animation inline-flex size-5">
                                {include file='__reaction_emojis.tpl' _reaction=$blog['i_reaction']}
                              </div>
                            </div>
                            <span class="reaction-btn-name ms-2 hidden sm:inline" style="color: {$system['reactions'][$blog['i_reaction']]['color']};">{__($system['reactions'][$blog['i_reaction']]['title'])}</span>
                          {/if}
                        </div>
                        {include file='__reactions_container.tpl' _handle="post"}
                      </div>
                      <div class="action-btn js_comment flex min-h-10 flex-1 cursor-pointer items-center justify-center rounded-field px-2 text-sm font-semibold transition-colors hover:bg-base-200 {if $blog['comments_disabled']}hidden{/if}">
                        <span class="icon-[tabler--message-circle] size-5" aria-hidden="true"></span>
                        <span class="ms-2 hidden sm:inline">{__("Comment")}</span>
                      </div>
                      {if $blog['privacy'] == "public"}
                        <div class="js_modal action-btn flex min-h-10 flex-1 cursor-pointer items-center justify-center rounded-field px-2 text-sm font-semibold transition-colors hover:bg-base-200" data-url="posts/share.php?do=create&post_id={$blog['post_id']}">
                          <span class="icon-[tabler--share-3] size-4" aria-hidden="true"></span>
                          <span class="ms-2 hidden sm:inline">{__("Share")}</span>
                        </div>
                      {/if}
                      {if $blog['author_id'] != $user->_data['user_id'] && $blog['tips_enabled']}
                        <div class="js_modal action-btn flex min-h-10 flex-1 cursor-pointer items-center justify-center rounded-field px-2 text-sm font-semibold transition-colors hover:bg-base-200" data-url="#send-tip" data-options='{ "id": "{$blog['author_id']}"}'>
                          <span class="icon-[tabler--coin] size-5" aria-hidden="true"></span>
                          <span class="ms-2 hidden sm:inline">{__("Tip")}</span>
                        </div>
                      {/if}
                    </div>
                    <!-- post actions -->
                  {/if}

                  <!-- comments -->
                  <div class="post-footer min-w-0 border-t border-base-content/10" id="blog-comments">
                    {if $user->_logged_in}
                      {include file='__feeds_post.comments.tpl' post=$blog}
                    {else}
                      <p class="py-4 text-sm">
                        <a class="font-medium" href="{$system['system_url']}/signin">{__("Please log in to like, share and comment!")}</a>
                      </p>
                    {/if}
                  </div>
                  <!-- comments -->
                </div>
              </div>
            </div>
          </article>
        {/if}

        {if $ads_footer}
          <div class="flex flex-col gap-4">
            {include file='_ads.tpl' ads=$ads_footer}
          </div>
        {/if}

        <!-- Schema.org structured data for blog post -->
        <script type="application/ld+json">
          {
            "@context": "https://schema.org",
            "@type": "BlogPosting",
            "headline": "{$blog['blog']['title']|escape:'html'}",
            "description": "{$blog['blog']['text']|strip_tags|truncate:200|escape:'html'}",
            "image": "{if $blog['blog']['cover']}{$blog['blog']['parsed_cover']}{/if}",
            "author": {
              "@type": "Person",
              "name": "{$blog['post_author_name']|escape:'html'}",
              "url": "{$blog['post_author_url']}"
            },
            "publisher": {
              "@type": "Organization",
              "name": "{$system['system_title']|escape:'html'}",
              "url": "{$system['system_url']}"
            },
            "datePublished": "{$blog['time']}",
            "dateModified": "{$blog['time']}",
            "mainEntityOfPage": {
              "@type": "WebPage",
              "@id": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}"
            },
            "url": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}",
            "articleSection": "{__($blog['blog']['category_name'])|escape:'html'}",
            "keywords": "{if $blog['blog']['parsed_tags']}{foreach $blog['blog']['parsed_tags'] as $tag}{$tag|escape:'html'}{if !$tag@last}, {/if}{/foreach}{/if}",
            "wordCount": "{$blog['blog']['text']|strip_tags|strlen}",
            "commentCount": "{$blog['comments_count']}",
            "interactionStatistic": [{
                "@type": "InteractionCounter",
                "interactionType": "https://schema.org/CommentAction",
                "userInteractionCount": "{$blog['comments_count']}"
              },
              {
                "@type": "InteractionCounter",
                "interactionType": "https://schema.org/ViewAction",
                "userInteractionCount": "{$blog['views_count']}"
              }
            ]
          }
        </script>
        <!-- Schema.org structured data for blog post -->
      </div>

      <!-- aside -->
      <aside class="flex min-w-0 flex-col gap-6">
        <div class="hidden flex-col gap-3 lg:flex">
          <form class="js_search-form" data-handle="blogs" role="search">
            <label class="input input-sm w-full">
              <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="search" class="grow" name="query" placeholder='{__("Search for blogs")}' aria-label='{__("Search for blogs")}'>
            </label>
          </form>
          <a class="heroui button button--primary button--sm button--full-width" href="{$system['system_url']}/blogs/new">
            <span class="icon-[tabler--pencil-plus] size-4" aria-hidden="true"></span>
            {__("Create New Blog")}
          </a>
        </div>
        {if $blogs_categories}
          <section class="hidden lg:block" aria-labelledby="blog-categories-title">
            <h2 class="mb-3 text-base font-semibold" id="blog-categories-title">{__("Categories")}</h2>
            <nav class="flex flex-wrap gap-1.5" aria-labelledby="blog-categories-title">
              {foreach $blogs_categories as $_category}
                {if $blog['blog']['category_id'] == $_category['category_id']}
                  <a class="badge badge-primary h-7 rounded-full px-3 text-xs font-medium text-primary-content!" href="{$system['system_url']}/blogs/category/{$_category['category_id']}/{$_category['category_url']}" aria-current="true">{__($_category['category_name'])}</a>
                {else}
                  <a class="badge h-7 rounded-full border-base-300 bg-base-100 px-3 text-xs font-medium text-base-content/75! transition-colors hover:border-primary/40 hover:bg-primary/5 hover:text-primary!" href="{$system['system_url']}/blogs/category/{$_category['category_id']}/{$_category['category_url']}">{__($_category['category_name'])}</a>
                {/if}
              {/foreach}
            </nav>
          </section>
        {/if}
        {if $latest_blogs}
          <section aria-labelledby="blog-read-more-title">
            <div class="mb-3 flex items-center justify-between gap-3">
              <h2 class="text-base font-semibold" id="blog-read-more-title">{__("Read More")}</h2>
              <a class="inline-flex items-center gap-0.5 text-xs font-medium text-primary! hover:underline" href="{$system['system_url']}/blogs">
                {__("See All")}
                <span class="icon-[tabler--chevron-right] size-3.5 rtl:rotate-180" aria-hidden="true"></span>
              </a>
            </div>
            <ul class="flex flex-col gap-4">
              {foreach $latest_blogs as $_blog}
                {include file='__feeds_blog.tpl' blog=$_blog}
              {/foreach}
            </ul>
          </section>
        {/if}
        {include file='_ads.tpl'}
        {include file='_widget.tpl'}
      </aside>
      <!-- aside -->
    </div>

  {elseif $view == "edit" || $view == "new"}

    <!-- page heading -->
    {if $view == "edit"}
      {include file='__page_header.tpl' _title=__("Edit Blog") _text=$blog['blog']['title'] _image="blogs.svg"}
    {else}
      {include file='__page_header.tpl' _title=__("Create New Blog") _text=__($system['system_description_blogs']) _image="blogs.svg"}
    {/if}
    <!-- page heading -->

    <div class="mx-auto mt-6 flex max-w-3xl flex-wrap items-center justify-between gap-3">
      <a class="heroui button button--ghost button--sm gap-1.5 px-2 text-base-content/70" href="{if $view == "edit"}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{else}{$system['system_url']}/blogs{/if}">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {if $view == "edit"}{__("Go Back")}{else}{__("Blogs")}{/if}
      </a>
      {if $view == "new" && $system['ai_posts_enabled']}
        <button type="button" class="js_modal heroui button button--tertiary button--sm rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] border-0 bg-linear-to-r from-violet-600 via-fuchsia-500 to-sky-500 text-white shadow-md shadow-fuchsia-500/25 hover:from-violet-700 hover:via-fuchsia-600 hover:to-sky-600" data-size="large" data-url="ai/modal.php?handle=blog">
          <span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span>
          {__("Generate with AI")}
        </button>
      {/if}
    </div>

    <div class="mt-4">
      {include file='blogs.form.tpl'}
    </div>

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}

{if $view == "new"}
  <script>
    $('input[type=radio][name=publish_to]').on('change', function() {
      switch ($(this).val()) {
        case 'timeline':
          $('#js_publish-to-page').hide();
          $('#js_publish-to-group').hide();
          $('#js_publish-to-event').hide();
          $('#tips-toggle-wrapper').fadeIn();
          $('#subscribers-toggle-wrapper').show();
          $('#collaborative-toggle-wrapper').show();
          break;
        case 'page':
          $('#js_publish-to-page').fadeIn();
          $('#js_publish-to-group').hide();
          $('#js_publish-to-event').hide();
          $('#tips-toggle-wrapper').hide();
          $('#subscribers-toggle-wrapper').show();
          $('#collaborative-toggle-wrapper').hide();
          break;
        case 'group':
          $('#js_publish-to-page').hide();
          $('#js_publish-to-group').fadeIn();
          $('#js_publish-to-event').hide();
          $('#tips-toggle-wrapper').fadeIn();
          $('#subscribers-toggle-wrapper').show();
          $('#collaborative-toggle-wrapper').show();
          break;
        case 'event':
          $('#js_publish-to-page').hide();
          $('#js_publish-to-group').hide();
          $('#js_publish-to-event').fadeIn();
          $('#tips-toggle-wrapper').fadeIn();
          $('#subscribers-toggle-wrapper').hide();
          $('#collaborative-toggle-wrapper').show();
          break;
      }
    });
  </script>
{/if}
