{if $view == "edit"}
  <!-- Schema.org structured data for blog edit page -->
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebPage",
      "name": "{__("Edit Blog")|escape:'html'}: {$blog['blog']['title']|escape:'html'}",
      "description": "{__("Edit blog post")|escape:'html'}: {$blog['blog']['title']|escape:'html'}",
      "url": "{$system['system_url']}/blogs/edit/{$blog['post_id']}",
      "publisher": {
        "@type": "Organization",
        "name": "{$system['system_title']|escape:'html'}",
        "url": "{$system['system_url']}"
      },
      "breadcrumb": {
        "@type": "BreadcrumbList",
        "itemListElement": [{
            "@type": "ListItem",
            "position": 1,
            "name": "{$system['system_title']|escape:'html'}",
            "item": "{$system['system_url']}"
          },
          {
            "@type": "ListItem",
            "position": 2,
            "name": "{__("Blogs")|escape:'html'}",
            "item": "{$system['system_url']}/blogs"
          },
          {
            "@type": "ListItem",
            "position": 3,
            "name": "{$blog['blog']['title']|escape:'html'}",
            "item": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}"
          },
          {
            "@type": "ListItem",
            "position": 4,
            "name": "{__("Edit")|escape:'html'}",
            "item": "{$system['system_url']}/blogs/edit/{$blog['post_id']}"
          }
        ]
      },
      "mainEntity": {
        "@type": "BlogPosting",
        "headline": "{$blog['blog']['title']|escape:'html'}",
        "description": "{$blog['blog']['text']|strip_tags|truncate:200|escape:'html'}",
        "image": "{if $blog['blog']['cover']}{$blog['blog']['parsed_cover']}{/if}",
        "author": {
          "@type": "Person",
          "name": "{$blog['post_author_name']|escape:'html'}",
          "url": "{$blog['post_author_url']}"
        },
        "datePublished": "{$blog['time']}",
        "dateModified": "{$blog['time']}",
        "url": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}"
      }
    }
  </script>
  <!-- Schema.org structured data for blog edit page -->
{else}
  <!-- Schema.org structured data for blog creation page -->
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebPage",
      "name": "{__("Create New Blog")|escape:'html'}",
      "description": "{__("Create and publish a new blog post")|escape:'html'}",
      "url": "{$system['system_url']}/blogs/new",
      "publisher": {
        "@type": "Organization",
        "name": "{$system['system_title']|escape:'html'}",
        "url": "{$system['system_url']}"
      },
      "breadcrumb": {
        "@type": "BreadcrumbList",
        "itemListElement": [{
            "@type": "ListItem",
            "position": 1,
            "name": "{$system['system_title']|escape:'html'}",
            "item": "{$system['system_url']}"
          },
          {
            "@type": "ListItem",
            "position": 2,
            "name": "{__("Blogs")|escape:'html'}",
            "item": "{$system['system_url']}/blogs"
          },
          {
            "@type": "ListItem",
            "position": 3,
            "name": "{__("Create New Blog")|escape:'html'}",
            "item": "{$system['system_url']}/blogs/new"
          }
        ]
      }
    }
  </script>
  <!-- Schema.org structured data for blog creation page -->
{/if}

<div class="js_ajax-forms-html mx-auto max-w-3xl" data-url="posts/blog.php?do={if $view == "edit"}edit&id={$blog['post_id']}{else}create{/if}">
  <div class="flex min-w-0 flex-col gap-6">

    {if $view == "new" && $system['paid_blogs_enabled']}
      <div class="flex items-start gap-3 rounded-xl border border-base-300 bg-base-100 p-4 text-sm text-base-content/80" role="note">
        <span class="icon-[tabler--coins] mt-0.5 size-5 shrink-0 text-warning" aria-hidden="true"></span>
        <span>
          {__("This blog post will cost you")} <span class="badge badge-soft">{$system['paid_blogs_cost']} {$system['system_currency']}</span> {__("to publish. The cost will be deducted from your wallet balance")}
        </span>
      </div>
    {/if}

    {if $view == "new"}
      <!-- publish to -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="blogs-section-publish">
        <header class="mb-5 flex items-center gap-3">
          <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">1</span>
          <h2 id="blogs-section-publish" class="text-lg font-semibold">{__("Publish To")}</h2>
        </header>
        <fieldset>
          <legend class="sr-only">{__("Publish To")}</legend>
          <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
            <label class="group flex min-w-0 cursor-pointer items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-3 transition-colors hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
              <input class="sr-only" type="radio" name="publish_to" id="publish_to_timeline" value="timeline" {if $share_to == "timeline"}checked{/if}>
              <span class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 transition-colors group-has-checked:bg-primary/15">
                {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="20px" height="20px"}
              </span>
              <span class="flex min-w-0 flex-col text-start">
                <span class="truncate text-sm font-semibold group-has-checked:text-primary" title='{__("Timeline")}'>{__("Timeline")}</span>
                <span class="truncate text-xs text-base-content/60" title='{__("Your own profile")}'>{__("Your own profile")}</span>
              </span>
              <span class="ms-auto flex size-5 shrink-0 items-center justify-center rounded-full border border-base-300 transition-colors group-has-checked:border-primary group-has-checked:bg-primary" aria-hidden="true">
                <span class="icon-[tabler--check] size-3.5 text-primary-content opacity-0 group-has-checked:opacity-100"></span>
              </span>
            </label>
            {if $system['pages_enabled'] && $pages}
              <label class="group flex min-w-0 cursor-pointer items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-3 transition-colors hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input class="sr-only" type="radio" name="publish_to" id="publish_to_page" value="page" {if $share_to == "page"}checked{/if}>
                <span class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 transition-colors group-has-checked:bg-primary/15">
                  {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="20px" height="20px"}
                </span>
                <span class="flex min-w-0 flex-col text-start">
                  <span class="truncate text-sm font-semibold group-has-checked:text-primary" title='{__("Page")}'>{__("Page")}</span>
                  <span class="truncate text-xs text-base-content/60" title='{__("A page you manage")}'>{__("A page you manage")}</span>
                </span>
                <span class="ms-auto flex size-5 shrink-0 items-center justify-center rounded-full border border-base-300 transition-colors group-has-checked:border-primary group-has-checked:bg-primary" aria-hidden="true">
                  <span class="icon-[tabler--check] size-3.5 text-primary-content opacity-0 group-has-checked:opacity-100"></span>
                </span>
              </label>
            {/if}
            {if $system['groups_enabled'] && $groups}
              <label class="group flex min-w-0 cursor-pointer items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-3 transition-colors hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input class="sr-only" type="radio" name="publish_to" id="publish_to_group" value="group" {if $share_to == "group"}checked{/if}>
                <span class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 transition-colors group-has-checked:bg-primary/15">
                  {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="20px" height="20px"}
                </span>
                <span class="flex min-w-0 flex-col text-start">
                  <span class="truncate text-sm font-semibold group-has-checked:text-primary" title='{__("Group")}'>{__("Group")}</span>
                  <span class="truncate text-xs text-base-content/60" title='{__("A group you are in")}'>{__("A group you are in")}</span>
                </span>
                <span class="ms-auto flex size-5 shrink-0 items-center justify-center rounded-full border border-base-300 transition-colors group-has-checked:border-primary group-has-checked:bg-primary" aria-hidden="true">
                  <span class="icon-[tabler--check] size-3.5 text-primary-content opacity-0 group-has-checked:opacity-100"></span>
                </span>
              </label>
            {/if}
            {if $system['events_enabled'] && $events}
              <label class="group flex min-w-0 cursor-pointer items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-3 transition-colors hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input class="sr-only" type="radio" name="publish_to" id="publish_to_event" value="event" {if $share_to == "event"}checked{/if}>
                <span class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 transition-colors group-has-checked:bg-primary/15">
                  {include file='__svg_icons.tpl' icon="events" class="main-icon" width="20px" height="20px"}
                </span>
                <span class="flex min-w-0 flex-col text-start">
                  <span class="truncate text-sm font-semibold group-has-checked:text-primary" title='{__("Event")}'>{__("Event")}</span>
                  <span class="truncate text-xs text-base-content/60" title='{__("An event you are in")}'>{__("An event you are in")}</span>
                </span>
                <span class="ms-auto flex size-5 shrink-0 items-center justify-center rounded-full border border-base-300 transition-colors group-has-checked:border-primary group-has-checked:bg-primary" aria-hidden="true">
                  <span class="icon-[tabler--check] size-3.5 text-primary-content opacity-0 group-has-checked:opacity-100"></span>
                </span>
              </label>
            {/if}
          </div>
        </fieldset>
        <div id="js_publish-to-page" {if $share_to != "page"}class="hidden"{/if}>
          <label class="label-text mt-5 mb-2 block" for="page_id">{__("Select Page")}</label>
          <select class="select w-full" name="page_id" id="page_id">
            {foreach $pages as $page}
              <option value="{$page['page_id']}" {if $share_to_page_id == $page['page_id']}selected{/if}>{$page['page_title']}</option>
            {/foreach}
          </select>
        </div>
        <div id="js_publish-to-group" {if $share_to != "group"}class="hidden"{/if}>
          <label class="label-text mt-5 mb-2 block" for="group_id">{__("Select Group")}</label>
          <select class="select w-full" name="group_id" id="group_id">
            {foreach $groups as $group}
              <option value="{$group['group_id']}" {if $share_to_group_id == $group['group_id']}selected{/if}>{$group['group_title']}</option>
            {/foreach}
          </select>
        </div>
        <div id="js_publish-to-event" {if $share_to != "event"}class="hidden"{/if}>
          <label class="label-text mt-5 mb-2 block" for="event_id">{__("Select Event")}</label>
          <select class="select w-full" name="event_id" id="event_id">
            {foreach $events as $event}
              <option value="{$event['event_id']}" {if $share_to_event_id == $event['event_id']}selected{/if}>{$event['event_title']}</option>
            {/foreach}
          </select>
        </div>
      </section>
      <!-- publish to -->
    {/if}

    <!-- article -->
    <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="blogs-section-article">
      <header class="mb-5 flex items-center gap-3">
        <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">{if $view == "new"}2{else}1{/if}</span>
        <h2 id="blogs-section-article" class="text-lg font-semibold">{__("Article")}</h2>
      </header>
      <div class="flex flex-col gap-5">
        <div>
          <label class="label-text mb-2 block" for="blog-title">{__("Title")}</label>
          <input class="input w-full {if $view == "new"}js_blog-title{/if}" id="blog-title" name="title" value="{$blog['blog']['title']}">
        </div>
        <div>
          <label class="label-text mb-2 block" for="{if $view == "new"}blog-editor{else}blog-editor-edit{/if}">{__("Content")}</label>
          <textarea name="text" class="textarea js_wysiwyg w-full" id="{if $view == "new"}blog-editor{else}blog-editor-edit{/if}">{$blog['blog']['text']}</textarea>
        </div>
      </div>
    </section>
    <!-- article -->

    <!-- cover -->
    <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="blogs-section-cover">
      <header class="mb-5 flex items-center gap-3">
        <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">{if $view == "new"}3{else}2{/if}</span>
        <h2 id="blogs-section-cover" class="text-lg font-semibold">{__("Cover")}</h2>
      </header>
      {if $view == "edit"}
        {include file='__x_image.tpl' _x_name="cover" _x_value=$blog['blog']['cover'] _x_class="aspect-[21/9] w-full"}
      {else}
        {include file='__x_image.tpl' _x_name="cover" _x_class="aspect-[21/9] w-full"}
      {/if}
    </section>
    <!-- cover -->

    <!-- taxonomy -->
    <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="blogs-section-taxonomy">
      <header class="mb-5 flex items-center gap-3">
        <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">{if $view == "new"}4{else}3{/if}</span>
        <h2 id="blogs-section-taxonomy" class="text-lg font-semibold">{__("Category & Tags")}</h2>
      </header>
      <div class="flex flex-col gap-5">
        <div>
          <label class="label-text mb-2 block" for="blog-category">{__("Category")}</label>
          <select class="select w-full" name="category" id="blog-category">
            <option>{__("Select Category")}</option>
            {foreach $blogs_categories as $category}
              {include file='__categories.recursive_options.tpl' data_category=$blog['blog']['category_id']}
            {/foreach}
          </select>
        </div>
        <div>
          <label class="label-text mb-2 block" for="blog-tags">{__("Tags")}</label>
          <input class="input w-full js_tagify [--input-color:var(--color-base-content)]!" id="blog-tags" name="tags" value="{$blog['blog']['tags']}">
          <span class="mt-2 block text-xs text-base-content/60">{__("Type a tag name and press Enter or Comma to add it")}</span>
        </div>
      </div>
    </section>
    <!-- taxonomy -->

    <!-- references -->
    <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="blogs-section-references">
      <header class="mb-5 flex items-center gap-3">
        <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">{if $view == "new"}5{else}4{/if}</span>
        <h2 id="blogs-section-references" class="text-lg font-semibold">{__("References")}</h2>
      </header>
      <div id="blog-references-list" class="flex flex-col gap-3">
        {if $view == "edit"}
          {foreach $blog['blog']['references'] as $key => $reference}
            <div class="auto-connect-node">
              <div class="flex flex-col gap-3 rounded-field border border-base-300 p-4">
                <input type="text" class="input w-full" name="references[{$key}][title]" placeholder="{__('Title')}" value="{$reference['title']}">
                <input type="text" class="input w-full" name="references[{$key}][link]" placeholder="{__('Link')}" value="{$reference['link']}">
                <span class="text-xs text-base-content/60">{__("Add a reference title and link to cite your source")}</span>
              </div>
            </div>
          {/foreach}
        {/if}
      </div>
      <button type="button" class="js_add-blog-reference heroui button button--tertiary mt-4 w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add reference")}
      </button>
    </section>
    <!-- references -->

    {if ($view == "edit" && (($user->_data['can_schedule_posts'] && $blog['still_scheduled']) || $system['adult_mode'] || ($user->_data['can_receive_tip'] && $blog['user_type'] != "page") || $user->_data['can_monetize_content'])) || ($view == "new" && ($user->_data['can_schedule_posts'] || $system['adult_mode'] || $user->_data['can_receive_tip'] || $user->_data['can_monetize_content'] || $user->_data['can_add_collaborative_posts']))}
      <!-- publishing options -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="blogs-section-options">
        <header class="mb-5 flex items-center gap-3">
          <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">{if $view == "new"}6{else}5{/if}</span>
          <h2 id="blogs-section-options" class="text-lg font-semibold">{__("Publishing Options")}</h2>
        </header>
        <div class="flex flex-col gap-2">

          <!-- schedule post -->
          {if $user->_data['can_schedule_posts'] && ($view == "new" || $blog['still_scheduled'])}
            <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5">
              <div class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-info">
                <span class="icon-[tabler--calendar-time] size-5" aria-hidden="true"></span>
              </div>
              <div class="min-w-0">
                <div class="text-sm font-medium">{__("Schedule Post")}</div>
                <div class="text-xs text-base-content/55">{__("Schedule your post for later")}</div>
              </div>
              <label class="inline-flex" for="is_schedule">
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px] js_publisher-schedule-toggle" type="checkbox" name="is_schedule" id="is_schedule" {if $view == "edit"}checked{/if}>
              </label>
            </div>
            <div class="space-y-1.5 {if $view == "new"}hidden{/if}" id="schedule-toggle-wrapper">
              <input type="datetime-local" class="input w-full js_blog-schedule-date" aria-label='{__("Schedule Post")}'>
              <input type="hidden" class="js_blog-schedule-utc" name="schedule_date" {if $view == "edit"}value="{$blog['time']}"{/if}>
              <div class="text-xs text-base-content/55">{__("Select a date and time for your post")}</div>
            </div>
          {/if}
          <!-- schedule post -->

          <!-- adult content -->
          {if $system['adult_mode']}
            <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5" id="adult-toggle-wrapper">
              <div class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-error">
                <span class="icon-[tabler--rating-18-plus] size-5" aria-hidden="true"></span>
              </div>
              <div class="min-w-0">
                <div class="text-sm font-medium">{__("Adult Content")}</div>
                <div class="text-xs text-base-content/55">{__("Share your post as adult content")}</div>
              </div>
              <label class="inline-flex" for="for_adult">
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" type="checkbox" name="for_adult" id="for_adult" {if $view == "edit" && $blog['for_adult']}checked{/if}>
              </label>
            </div>
          {/if}
          <!-- adult content -->

          <!-- enable tips -->
          {if $user->_data['can_receive_tip'] && ($view == "new" || $blog['user_type'] != "page")}
            <div id="tips-toggle-wrapper" {if $view == "new" && $share_to == "page"}class="hidden"{/if}>
              <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5">
                <div class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-warning">
                  <span class="icon-[tabler--coin] size-5" aria-hidden="true"></span>
                </div>
                <div class="min-w-0">
                  <div class="text-sm font-medium">{__("Enable Tips")}</div>
                  <div class="text-xs text-base-content/55">{__("Allow people to send you tips")}</div>
                </div>
                <label class="inline-flex" for="tips_enabled">
                  <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" type="checkbox" name="tips_enabled" id="tips_enabled" {if $view == "edit" && $blog['tips_enabled']}checked{/if}>
                </label>
              </div>
            </div>
          {/if}
          <!-- enable tips -->

          <!-- only for subscribers -->
          {if $user->_data['can_monetize_content']}
            <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5 {if $view == "edit" && $blog['is_paid']}disabled{/if}" id="subscribers-toggle-wrapper">
              <div class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-accent">
                <span class="icon-[tabler--users] size-5" aria-hidden="true"></span>
              </div>
              <div class="min-w-0">
                <div class="text-sm font-medium">{__("Subscribers Only")}</div>
                <div class="text-xs text-base-content/55">{__("Share this post to")} {__("subscribers only")}</div>
              </div>
              <label class="inline-flex" for="subscribers_only">
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px] [--color-neutral:var(--color-base-content)] disabled:before:bg-current js_publisher-subscribers-toggle" type="checkbox" name="subscribers_only" id="subscribers_only" {if $view == "edit" && $blog['for_subscriptions']}checked{/if} {if $view == "edit" && $blog['is_paid']}disabled{/if}>
              </label>
            </div>
            <div class="space-y-1.5 {if !($view == "edit" && $blog['for_subscriptions'])}hidden{/if}" id="subscriptions-image-wrapper">
              {if $view == "edit"}
                {include file='__x_image.tpl' _x_name="subscriptions_image" _x_value=$blog['subscriptions_image'] _x_class="min-h-32 w-full" _x_blur=true}
              {else}
                {include file='__x_image.tpl' _x_name="subscriptions_image" _x_class="min-h-32 w-full" _x_blur=true}
              {/if}
              <div class="text-xs text-base-content/55">{__("Upload a preview image for your content (This image will be blured)")}</div>
            </div>
          {/if}
          <!-- only for subscribers -->

          <!-- paid post -->
          {if $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
            <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5 {if $view == "edit" && $blog['for_subscriptions']}disabled{/if}" id="paid-toggle-wrapper">
              <div class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-success">
                <span class="icon-[tabler--currency-dollar] size-5" aria-hidden="true"></span>
              </div>
              <div class="min-w-0">
                <div class="text-sm font-medium">{__("Paid Post")}</div>
                <div class="text-xs text-base-content/55">{__("Set a price to your post")}</div>
              </div>
              <label class="inline-flex" for="paid_post">
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px] [--color-neutral:var(--color-base-content)] disabled:before:bg-current js_publisher-paid-toggle" type="checkbox" name="paid_post" id="paid_post" {if $view == "edit" && $blog['is_paid']}checked{/if} {if $view == "edit" && $blog['for_subscriptions']}disabled{/if}>
              </label>
            </div>
            <div class="space-y-1.5 {if !($view == "edit" && $blog['is_paid'])}hidden{/if}" id="paid-price-wrapper">
              <input type="text" class="input w-full" name="paid_post_price" placeholder="{__("Price")} ({$system['system_currency']})" {if $view == "edit"}value="{$blog['post_price']}"{/if}>
            </div>
            <div class="space-y-1.5 {if !($view == "edit" && $blog['is_paid'])}hidden{/if}" id="paid-text-wrapper">
              <textarea class="textarea min-h-20 w-full" name="paid_post_text" rows="3" placeholder="{__("Paid Content Description")}">{if $view == "edit"}{$blog['paid_text']}{/if}</textarea>
            </div>
            <div class="space-y-1.5 {if !($view == "edit" && $blog['is_paid'])}hidden{/if}" id="paid-image-wrapper">
              {if $view == "edit"}
                {include file='__x_image.tpl' _x_name="paid_image" _x_value=$blog['paid_image'] _x_class="min-h-32 w-full" _x_blur=true}
              {else}
                {include file='__x_image.tpl' _x_name="paid_image" _x_class="min-h-32 w-full" _x_blur=true}
              {/if}
              <div class="text-xs text-base-content/55">{__("Upload a preview image for your content (This image will be blured)")}</div>
            </div>
          {/if}
          <!-- paid post -->

          <!-- collaborative post -->
          {if $view == "new" && $user->_data['can_add_collaborative_posts']}
            <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5" id="collaborative-toggle-wrapper">
              <div class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-primary">
                <span class="icon-[tabler--users-plus] size-5" aria-hidden="true"></span>
              </div>
              <div class="min-w-0">
                <div class="text-sm font-medium">{__("Collaborative Post")}</div>
                <div class="text-xs text-base-content/55">{__("Share your post with others")}</div>
              </div>
              <label class="inline-flex" for="collaborative_post">
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px] js_publisher-collaborative-toggle" type="checkbox" name="collaborative_post" id="collaborative_post">
              </label>
            </div>
            <div class="space-y-1.5 hidden" id="collaborative-users-wrapper">
              <input type="text" class="js_tagify-ajax hidden min-h-10 w-full items-center! rounded-field bg-base-100 text-sm max-md:text-base [--placeholder-color-focus:color-mix(in_oklab,var(--color-base-content)_35%,transparent)]! [--placeholder-color:color-mix(in_oklab,var(--color-base-content)_45%,transparent)]! [--tag-bg:var(--color-base-200)]! [--tag-border-radius:9999px]! [--tag-hover:var(--color-base-300)]! [--tag-remove-btn-color:var(--color-base-content)]! [--tag-text-color:var(--color-base-content)]! [--tags-border-color:var(--color-base-300)]! [--tags-focus-border-color:var(--color-primary)]! [--tags-hover-border-color:color-mix(in_oklab,var(--color-base-content)_25%,transparent)]!" data-handle="collaborative_users" name="collaborative_users" placeholder='{__("Search")}'>
              <div class="text-xs text-base-content/55">{__("Enter the users to collaborate with")}</div>
            </div>
            {if $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
              <div class="space-y-1.5 hidden" id="collaborative-percent-wrapper">
                <input type="number" min="0" max="100" class="input w-full" name="collaborative_percent">
                <div class="text-xs text-base-content/55">{__("Enter the % of the revenue that you want to give to the collaborators (only for paid posts)")}</div>
              </div>
            {/if}
          {/if}
          <!-- collaborative post -->

        </div>
      </section>
      <!-- publishing options -->
    {/if}

    <div class="flex flex-col-reverse gap-2 sm:flex-row sm:flex-wrap sm:items-center sm:justify-end">
      {if $view == "edit"}
        <button type="button" class="heroui button button--danger w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_delete-blog" data-id="{$blog['post_id']}">
          <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
          {__("Delete Blog")}
        </button>
      {/if}
      <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Publish")}</button>
    </div>

    <!-- error -->
    <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
    <!-- error -->

  </div>
</div>
