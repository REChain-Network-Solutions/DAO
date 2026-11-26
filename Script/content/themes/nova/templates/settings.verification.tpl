{if $case == "verified"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--rosette-discount-check]" _title=__("Verification") _text=__("Request a verified badge for your account")}
    <div class="card-body items-center gap-3 py-12 text-center">
      <span class="inline-flex size-16 items-center justify-center rounded-full bg-primary/10 text-primary" aria-hidden="true">
        <span class="icon-[tabler--rosette-discount-check-filled] size-8"></span>
      </span>
      <h3 class="mt-2 text-lg font-semibold">{__("Congratulations")}</h3>
      <p class="max-w-sm text-sm text-base-content/60">{__("This account is verified")}</p>
    </div>
  </div>
{elseif $case == "pending"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--rosette-discount-check]" _title=__("Verification") _text=__("Request a verified badge for your account")}
    <div class="card-body items-center gap-3 py-12 text-center">
      <span class="inline-flex size-16 items-center justify-center rounded-full bg-warning/10 text-warning" aria-hidden="true">
        <span class="icon-[tabler--hourglass] size-8"></span>
      </span>
      <h3 class="mt-2 text-lg font-semibold">{__("Pending")}</h3>
      <p class="max-w-sm text-sm text-base-content/60">{__("Your verification request is still awaiting admin approval")}</p>
    </div>
  </div>
{else}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/verify.php?node=user">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--rosette-discount-check]" _title=__("Verification") _text=__("Request a verified badge for your account")}
      <div class="card-body gap-6 pt-6">
        {if $case == "declined"}
          <div class="alert alert-error flex items-start gap-3 leading-5" role="alert">
            <span class="icon-[tabler--circle-x] size-5 shrink-0" aria-hidden="true"></span>
            <div class="min-w-0">
              <div class="font-medium">{__("Sorry")}</div>
              <p class="mt-0.5 text-sm">{__("Your verification request has been declined by the admin")}</p>
            </div>
          </div>
        {/if}

        {if $system['verification_docs_required'] && ($system['verification_user_photo_enabled'] || $system['verification_user_passport_enabled'])}
          <!-- documents -->
          <section class="flex flex-col gap-4">
            <div>
              <h3 class="text-sm font-semibold">{__("Verification Documents")}</h3>
              <p class="mt-0.5 text-sm text-base-content/60">{__("Please attach the documents below")}</p>
            </div>
            <div class="grid gap-4 sm:grid-cols-2">
              {if $system['verification_user_photo_enabled']}
                <div class="flex flex-col gap-2">
                  <div class="flex items-center gap-2 text-sm font-semibold" id="verification-photo-label">
                    <span class="icon-[tabler--user-circle] size-4 text-base-content/60" aria-hidden="true"></span>
                    {__($system['verification_user_photo_title'])}
                  </div>
                  {include file='__x_image.tpl' _x_name="photo" _x_class="h-44 w-full"}
                </div>
              {/if}
              {if $system['verification_user_passport_enabled']}
                <div class="flex flex-col gap-2">
                  <div class="flex items-center gap-2 text-sm font-semibold" id="verification-passport-label">
                    <span class="icon-[tabler--id] size-4 text-base-content/60" aria-hidden="true"></span>
                    {__($system['verification_user_passport_title'])}
                  </div>
                  {include file='__x_image.tpl' _x_name="passport" _x_class="h-44 w-full"}
                </div>
              {/if}
            </div>
          </section>
          <!-- documents -->
        {/if}

        <div class="w-full">
          <label class="label-text mb-1.5 block" for="message">{__("Additional Information")}</label>
          <textarea class="textarea w-full" id="message" name="message" rows="4" dir="auto"></textarea>
          <p class="helper-text">{__("Please share why your account should be verified")}</p>
        </div>

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
          <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
          {__("Send")}
        </button>
      </div>
    </form>
  </div>
{/if}
