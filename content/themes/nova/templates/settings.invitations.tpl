<div class="flex flex-col gap-6">
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
        <span class="icon-[tabler--mail-forward] size-5"></span>
      </span>
      <div class="min-w-0 grow">
        <h2 class="card-title text-lg">{__("Invitations")}</h2>
        <p class="text-sm text-base-content/60">{__("Invite people to the site")}</p>
      </div>
      <button type="button" data-url="users/invitations.php?do=generate" class="js_modal heroui button button--primary button--sm w-full sm:ms-auto sm:w-auto shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Generate New Code")}
      </button>
    </div>
    <div class="card-body gap-6 pt-6">
      <!-- invitations system -->
      <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
        <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
        <div class="min-w-0">
          <div class="font-medium">{__("Invitations System")}</div>
          <p class="mt-0.5 text-sm">
            {__("You have")} <strong>{if $system['invitation_user_limit'] == 0}{__("Unlimited")}{else}{$system['invitation_user_limit']}{/if}</strong> {__("invitations")} {if $system['invitation_user_limit'] != 0}{__("every")} {__($system['invitation_expire_period']|ucfirst)}{/if}
          </p>
        </div>
      </div>
      <!-- invitations system -->

      <!-- stats -->
      <div class="grid gap-4 sm:grid-cols-3">
        <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
            <span class="icon-[tabler--ticket] size-5"></span>
          </span>
          <div class="min-w-0">
            <div class="truncate text-sm text-base-content/60" title="{__("Available Invitations")}">{__("Available Invitations")}</div>
            <div class="flex h-7 items-center text-xl font-semibold">
              {if $system['invitation_user_limit'] == 0}
                <span class="icon-[tabler--infinity] size-6" aria-hidden="true"></span>
                <span class="sr-only">{__("Unlimited")}</span>
              {else}
                {$invitation_codes_stats['available']}
              {/if}
            </div>
          </div>
        </div>
        <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
            <span class="icon-[tabler--sparkles] size-5"></span>
          </span>
          <div class="min-w-0">
            <div class="truncate text-sm text-base-content/60" title="{__("Generated Invitations")}">{__("Generated Invitations")}</div>
            <div class="flex h-7 items-center text-xl font-semibold">{$invitation_codes_stats['generated']}</div>
          </div>
        </div>
        <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-warning" aria-hidden="true">
            <span class="icon-[tabler--user-check] size-5"></span>
          </span>
          <div class="min-w-0">
            <div class="truncate text-sm text-base-content/60" title="{__("Used Invitations")}">{__("Used Invitations")}</div>
            <div class="flex h-7 items-center text-xl font-semibold">{$invitation_codes_stats['used']}</div>
          </div>
        </div>
      </div>
      <!-- stats -->
    </div>
  </div>

  <!-- invitation codes -->
  <div class="card border border-base-300 bg-base-100 shadow-none">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--ticket]" _title=__("Your Invitations Codes")}
    <div class="card-body gap-6 pt-6">
      {if $invitation_codes}
        <div class="[&_.js-flyonui-datatable-toolbar]:px-0 [&_.js-flyonui-datatable-footer]:px-0">
          <table class="table table-zebra min-w-[640px] js_dataTable">
            <thead>
              <tr>
                <th>{__("Invitation Code")}</th>
                <th>{__("Created")}</th>
                <th>{__("Used")}</th>
                <th>{__("Used By")}</th>
                <th class="text-end">{__("Actions")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $invitation_codes as $invitation_code}
                <tr>
                  <td>
                    <code class="rounded-lg border border-base-300 bg-base-200/60 px-2 py-1 text-sm font-semibold tracking-wider" dir="ltr">{$invitation_code['code']}</code>
                  </td>
                  <td class="text-base-content/60">{$invitation_code['created_date']|date_format:"%e %B %Y"}</td>
                  <td>
                    {if $invitation_code['used']}
                      <span class="badge badge-soft rounded-full badge-lg badge-error">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft rounded-full badge-lg badge-success">{__("No")}</span>
                    {/if}
                  </td>
                  <td>
                    {if $invitation_code['used']}
                      <a class="flex min-w-0 items-center gap-2.5 text-base-content! hover:text-primary!" target="_blank" href="{$system['system_url']}/{$invitation_code['user_name']}">
                        <img class="size-8 shrink-0 rounded-full object-cover" src="{$invitation_code['user_picture']}" alt="">
                        <span class="truncate text-sm font-medium" title="{$invitation_code['user_firstname']} {$invitation_code['user_lastname']}">{$invitation_code['user_firstname']} {$invitation_code['user_lastname']}</span>
                      </a>
                    {else}
                      <span class="text-base-content/40">—</span>
                    {/if}
                  </td>
                  <td class="text-end">
                    {if !$invitation_code['used']}
                      <button type="button" data-url="users/invitations.php?do=share&code={$invitation_code['code']}{if $system['affiliates_enabled']}&ref={$user->_data['user_name']}{/if}" class="js_modal heroui button button--tertiary text-base-content button--sm rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                        <span class="icon-[tabler--share] size-4" aria-hidden="true"></span>
                        {__("Share")}
                      </button>
                    {/if}
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--ticket]"}
      {/if}
    </div>
  </div>
  <!-- invitation codes -->
</div>
