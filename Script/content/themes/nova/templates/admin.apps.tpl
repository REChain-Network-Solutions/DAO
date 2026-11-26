<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-apps-title">
  <div class="admin-form-layout mx-auto flex w-full max-w-[64rem] flex-col gap-6">

    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-apps-title" class="text-2xl font-semibold">
          {__("Native Apps")}
        </h1>
        <p class="text-base-content/60 text-sm">
          {__("Get the official Sngine native apps for your website.")}
        </p>
      </div>
    </header>

    <!-- apps -->
    <section class="flex flex-col gap-4" aria-label="{__("Native Apps")}">

      <!-- Sngine Messenger -->
      <article class="card overflow-hidden border border-base-300 bg-base-100 shadow-none" aria-labelledby="admin-apps-messenger">
        <div class="flex flex-col gap-6 bg-linear-to-br from-primary/10 via-transparent to-transparent p-6 sm:p-8">
          <div class="flex items-start gap-4">
            <img class="size-14 shrink-0 rounded-2xl object-cover" src="{$system['system_url']}/content/themes/{$system['theme']}/images/apps/messaging.jpg" alt="Sngine Messenger" width="56" height="56">
            <div class="min-w-0 flex-1">
              <div class="flex flex-wrap items-center gap-2">
                <h2 id="admin-apps-messenger" class="text-lg font-semibold">Sngine Messenger</h2>
                <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Available")}</span>
              </div>
              <p class="mt-1 text-base-content/60 text-sm">{__("Native messaging apps for your members")}</p>
            </div>
          </div>

          <!-- platforms -->
          <ul class="grid gap-3 sm:grid-cols-3">
            <li class="flex flex-col gap-3 rounded-xl border border-base-300 bg-base-100 p-4">
              <span class="flex items-center justify-between gap-2">
                <span class="icon-[tabler--brand-apple] size-6 shrink-0" aria-hidden="true"></span>
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-success" title="{__("Available")}" aria-hidden="true"></span>
                <span class="sr-only">{__("Available")}</span>
              </span>
              <span>
                <span class="block text-sm font-semibold">iOS</span>
              </span>
            </li>
            <li class="flex flex-col gap-3 rounded-xl border border-base-300 bg-base-100 p-4">
              <span class="flex items-center justify-between gap-2">
                <span class="icon-[tabler--brand-android] size-6 shrink-0" aria-hidden="true"></span>
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-success" title="{__("Available")}" aria-hidden="true"></span>
                <span class="sr-only">{__("Available")}</span>
              </span>
              <span>
                <span class="block text-sm font-semibold">Android</span>
              </span>
            </li>
            <li class="flex flex-col gap-3 rounded-xl border border-dashed border-base-300 p-4 text-base-content/60">
              <span class="flex items-center justify-between gap-2">
                <span class="icon-[tabler--device-desktop] size-6 shrink-0" aria-hidden="true"></span>
                <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Coming Soon")}</span>
              </span>
              <span>
                <span class="block text-sm font-semibold">{__("Desktop")}</span>
                <span class="block text-xs">Windows, macOS, Linux</span>
              </span>
            </li>
          </ul>
          <!-- platforms -->
        </div>
        <div class="flex flex-col gap-3 border-t border-base-300 px-6 py-4 sm:flex-row sm:items-center sm:justify-end sm:px-8">
          <a href="https://zamblek.com/products/sngine-messaging-apps" class="btn btn-primary w-full sm:w-auto" target="_blank" rel="noopener">
            {__("Buy Now")}
            <span class="icon-[tabler--external-link] size-4" aria-hidden="true"></span>
          </a>
        </div>
      </article>
      <!-- Sngine Messenger -->

    </section>
    <!-- apps -->

  </div>
</section>
