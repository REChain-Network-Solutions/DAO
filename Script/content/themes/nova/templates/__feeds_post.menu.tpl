<!-- post menu -->
{if $user->_logged_in && !$_shared && $_get != "posts_information"}
  <div class="dropdown relative inline-flex shrink-0 [--offset:4] {if !$_reel}-me-1.5 -mt-0.5{/if} {if $_reel}{if $system['language']['dir'] == 'RTL'}[--placement:top-start]{else}[--placement:top-end]{/if}{elseif $system['language']['dir'] == 'RTL'}[--placement:bottom-start]{else}[--placement:bottom-end]{/if}">
    <button type="button" class="dropdown-toggle {if $_reel}flex size-10 items-center justify-center rounded-full bg-black/35 text-white transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20{else}heroui button button--ghost button--sm button--icon-only text-base-content/55 hover:text-base-content dropdown-open:bg-base-content/10 dropdown-open:text-base-content{/if}" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Post Actions")}">
      <span class="icon-[tabler--dots] size-5" aria-hidden="true"></span>
    </button>
    <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden max-h-[min(70dvh,34rem)] w-72 max-w-[calc(100vw-2rem)] overflow-y-auto rounded-box border border-base-content/10 bg-base-100 p-1.5 text-base-content shadow-xl" role="menu" aria-label="{__("Post Actions")}">

      <!-- availability -->
      {if $_post['manage_post'] && $_post['post_type'] == "product"}
        {if $_post['product']['available']}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_sold-post" role="menuitem">
            <i class="icon-[tabler--shopping-bag] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Mark as Sold")}</span>
          </button>
        {else}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unsold-post" role="menuitem">
            <i class="icon-[tabler--shopping-bag] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Mark as Available")}</span>
          </button>
        {/if}
      {/if}
      {if $_post['manage_post'] && $_post['post_type'] == "job"}
        {if $_post['job']['available']}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_closed-post" role="menuitem">
            <i class="icon-[tabler--briefcase] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Mark as Closed")}</span>
          </button>
        {else}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unclosed-post" role="menuitem">
            <i class="icon-[tabler--briefcase] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Mark as Available")}</span>
          </button>
        {/if}
      {/if}
      {if $_post['manage_post'] && $_post['post_type'] == "course"}
        {if $_post['course']['available']}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_closed-post" role="menuitem">
            <i class="icon-[tabler--book-2] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Mark as Closed")}</span>
          </button>
        {else}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unclosed-post" role="menuitem">
            <i class="icon-[tabler--book-2] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Mark as Available")}</span>
          </button>
        {/if}
      {/if}
      <!-- availability -->

      {if !$_reel}
      <!-- save -->
      {if $_post['i_save']}
        <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unsave-post" role="menuitem">
          <i class="icon-[tabler--bookmark] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
          <span class="min-w-0 flex-1 wrap-break-word">{__("Unsave Post")}</span>
        </button>
      {else}
        <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_save-post" role="menuitem">
          <i class="icon-[tabler--bookmark] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
          <span class="min-w-0 flex-1 wrap-break-word">{__("Save Post")}</span>
        </button>
      {/if}
      <!-- save -->

      <div class="-mx-1.5 my-1.5 border-t border-base-content/10" role="separator"></div>
      {/if}

      {if $_post['manage_post']}
        <!-- edit -->
        {if $_post['can_edit_post']}
        {if $_post['post_type'] == "rich_text"}
          <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" data-size="extra-large" data-static="true" data-url="posts/rich_text.php?do=edit&post_id={$_post['post_id']}" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Post")}</span>
          </button>
        {elseif $_post['post_type'] == "article"}
          <a href="{$system['system_url']}/blogs/edit/{$_post['post_id']}" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Blog")}</span>
          </a>
        {elseif $_post['post_type'] == "product"}
          <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" data-url="posts/product.php?do=edit&post_id={$_post['post_id']}" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Product")}</span>
          </button>
        {elseif $_post['post_type'] == "funding"}
          <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" data-url="posts/funding.php?do=edit&post_id={$_post['post_id']}" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Funding")}</span>
          </button>
        {elseif $_post['post_type'] == "offer"}
          <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" data-url="posts/offer.php?do=edit&post_id={$_post['post_id']}" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Offer")}</span>
          </button>
        {elseif $_post['post_type'] == "job"}
          <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" data-url="posts/job.php?do=edit&post_id={$_post['post_id']}" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Job")}</span>
          </button>
        {elseif $_post['post_type'] == "course"}
          <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" data-url="posts/course.php?do=edit&post_id={$_post['post_id']}" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Course")}</span>
          </button>
        {else}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_modal" data-url="posts/publisher.php?do=edit&amp;post_id={$_post['post_id']}" data-size="publisher" data-static="true" role="menuitem">
            <i class="icon-[tabler--pencil] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Edit Post")}</span>
          </button>
        {/if}
        {/if}
        <!-- edit -->

        <!-- pin -->
        {if !$_post['still_scheduled'] && !$_post['is_anonymous']}
          {if (!$_post['in_group'] && !$_post['in_event']) || ($_post['in_group'] && $_post['is_group_admin']) || ($_post['in_event'] && $_post['is_event_admin'])}
            {if $_post['pinned']}
              <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unpin-post" role="menuitem">
                <i class="icon-[tabler--pin] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
                <span class="min-w-0 flex-1 wrap-break-word">{__("Unpin Post")}</span>
              </button>
            {else}
              <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_pin-post" role="menuitem">
                <i class="icon-[tabler--pin] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
                <span class="min-w-0 flex-1 wrap-break-word">{__("Pin Post")}</span>
              </button>
            {/if}
          {/if}
        {/if}
        <!-- pin -->

        <!-- boost -->
        {if !$_post['still_scheduled'] && $system['packages_enabled'] && !$_post['in_group'] && !$_post['in_event']}
          {if $_post['boosted']}
            <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unboost-post" role="menuitem">
              <i class="icon-[tabler--rocket] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("Unboost Post")}</span>
            </button>
          {elseif $user->_data['can_boost_posts']}
            <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_boost-post" role="menuitem">
              <i class="icon-[tabler--rocket] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("Boost Post")}</span>
            </button>
          {else}
            <a href="{$system['system_url']}/packages" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" role="menuitem">
              <i class="icon-[tabler--rocket] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("Boost Post")}</span>
              <span class="icon-[tabler--crown] size-4 shrink-0 text-warning" aria-hidden="true"></span>
            </a>
          {/if}
        {/if}
        <!-- boost -->

        <!-- monetization -->
        {if $_post['can_be_for_subscriptions'] && $_post['post_type'] != "rich_text"}
          {if $_post['for_subscriptions']}
            <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_unmonetize-post" role="menuitem">
              <i class="icon-[tabler--coin] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("For Everyone")}</span>
            </button>
          {else}
            <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_monetize-post" role="menuitem">
              <i class="icon-[tabler--coin] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("For Subscribers Only")}</span>
            </button>
          {/if}
        {/if}
        <!-- monetization -->

        <div class="-mx-1.5 my-1.5 border-t border-base-content/10" role="separator"></div>

        <!-- hide -->
        {if $_post['user_type'] == "user" && !$_post['in_group'] && !$_post['in_event'] && !$_post['is_anonymous']}
          {if $_post['is_hidden']}
            <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_allow-post" role="menuitem">
              <i class="icon-[tabler--eye-off] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("Allow on Timeline")}</span>
            </button>
          {else}
            <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_disallow-post" role="menuitem">
              <i class="icon-[tabler--eye-off] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
              <span class="min-w-0 flex-1 wrap-break-word">{__("Hide from Timeline")}</span>
            </button>
          {/if}
        {/if}
        <!-- hide -->

        <!-- comments -->
        {if $_post['comments_disabled']}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_enable-post-comments" role="menuitem">
            <i class="icon-[tabler--message-circle] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Turn on Commenting")}</span>
          </button>
        {else}
          <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_disable-post-comments" role="menuitem">
            <i class="icon-[tabler--message-circle] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">{__("Turn off Commenting")}</span>
          </button>
        {/if}
        <!-- comments -->
      {else}
        <!-- unfollow -->
        {if $_post['user_type'] == "user" && !$_post['is_anonymous']}
          <button type="button" class="dropdown-close dropdown-item items-start gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_hide-author" data-author-id="{$_post['user_id']}" data-author-name="{$_post['post_author_name']}" role="menuitem">
            <i class="icon-[tabler--user-minus] mt-px size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
            <span class="min-w-0 flex-1 wrap-break-word">
              <span class="block">{__("Unfollow")} {if $system['show_usernames_enabled']}{$_post['user_name']}{else}{$_post['user_firstname']}{/if}</span>
              <span class="mt-0.5 block text-xs font-normal leading-4 text-base-content/55">{__("Stop seeing posts but stay friends")}</span>
            </span>
          </button>
        {/if}
        <!-- unfollow -->

        <!-- hide -->
        <button type="button" class="dropdown-close dropdown-item items-start gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content! js_hide-post" role="menuitem">
          <i class="icon-[tabler--eye-off] mt-px size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
          <span class="min-w-0 flex-1 wrap-break-word">
            <span class="block">{__("Hide this post")}</span>
            <span class="mt-0.5 block text-xs font-normal leading-4 text-base-content/55">{__("See fewer posts like this")}</span>
          </span>
        </button>
        <!-- hide -->
      {/if}

      <div class="-mx-1.5 my-1.5 border-t border-base-content/10" role="separator"></div>

      <!-- links -->
      <a href="{$system['system_url']}/posts/{$_post['post_id']}" target="_blank" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" rel="noopener" role="menuitem">
        <i class="icon-[tabler--external-link] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
        <span class="min-w-0 flex-1 wrap-break-word">{__("Open post in new tab")}</span>
      </a>
      {if $_post['is_anonymous'] && ($user->_is_admin || $user->_is_moderator)}
        <a href="{$_post['post_author_url']}" target="_blank" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-base-content!" rel="noopener" role="menuitem">
          <i class="icon-[tabler--spy] size-[1.125rem] shrink-0 text-base-content/55" aria-hidden="true"></i>
          <span class="min-w-0 flex-1 wrap-break-word">{__("Open Author Profile")}</span>
        </a>
      {/if}
      <!-- links -->

      <div class="-mx-1.5 my-1.5 border-t border-base-content/10" role="separator"></div>

      {if $_post['manage_post']}
        <!-- delete -->
        <button type="button" class="dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-post" role="menuitem">
          <i class="icon-[tabler--trash] size-[1.125rem] shrink-0" aria-hidden="true"></i>
          <span class="min-w-0 flex-1 wrap-break-word">{__("Delete Post")}</span>
        </button>
        <!-- delete -->
      {else}
        <!-- report -->
        <button type="button" class="js_modal dropdown-close dropdown-item gap-3 rounded-field px-3 py-2 text-start text-sm font-medium whitespace-normal text-error! hover:bg-error/10! focus-visible:bg-error/10!" data-url="data/report.php?do=create&handle=post&id={$_post['post_id']}" role="menuitem">
          <i class="icon-[tabler--flag] size-[1.125rem] shrink-0" aria-hidden="true"></i>
          <span class="min-w-0 flex-1 wrap-break-word">{__("Report post")}</span>
        </button>
        <!-- report -->
      {/if}
    </div>
  </div>
{/if}
<!-- post menu -->
