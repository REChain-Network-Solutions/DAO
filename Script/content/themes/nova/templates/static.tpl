{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {include file='__page_header.tpl' _title=__($static_page['page_title']) _text=__($system['system_title']) _image="static.svg"}
  <!-- page heading -->

  <div class="mt-6">

    <!-- page text -->
    <article class="w-full min-w-0 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 px-6 py-8 sm:px-10 sm:py-10">
      <div class="static-page-content text-base leading-7 break-words text-base-content/90 [&>:first-child]:mt-0 [&>:last-child]:mb-0 [&_a]:text-primary [&_a]:underline [&_a]:underline-offset-2 [&_a:hover]:no-underline [&_blockquote]:my-6 [&_blockquote]:rounded-e-2xl [&_blockquote]:border-s-4 [&_blockquote]:border-primary/40 [&_blockquote]:bg-primary/5 [&_blockquote]:py-3 [&_blockquote]:ps-4 [&_blockquote]:pe-4 [&_blockquote]:text-base-content/75 [&_blockquote]:italic [&_code]:rounded [&_code]:bg-base-200 [&_code]:px-1.5 [&_code]:py-0.5 [&_code]:text-sm [&_h1]:mt-10 [&_h1]:mb-4 [&_h1]:text-3xl [&_h1]:font-bold [&_h1]:tracking-tight [&_h2]:mt-10 [&_h2]:mb-4 [&_h2]:text-2xl [&_h2]:font-bold [&_h2]:tracking-tight [&_h3]:mt-8 [&_h3]:mb-3 [&_h3]:text-xl [&_h3]:font-semibold [&_h4]:mt-6 [&_h4]:mb-2 [&_h4]:text-lg [&_h4]:font-semibold [&_h5]:mt-6 [&_h5]:mb-2 [&_h5]:font-semibold [&_h6]:mt-6 [&_h6]:mb-2 [&_h6]:font-semibold [&_hr]:my-8 [&_hr]:border-base-300 [&_img]:my-6 [&_img]:rounded-2xl [&_li]:leading-7 [&_ol]:my-4 [&_ol]:list-decimal [&_ol]:space-y-2 [&_ol]:ps-6 [&_p]:my-4 [&_pre]:my-6 [&_pre]:overflow-x-auto [&_pre]:rounded-2xl [&_pre]:bg-base-200 [&_pre]:p-4 [&_pre_code]:bg-transparent [&_pre_code]:p-0 [&_strong]:font-semibold [&_strong]:text-base-content [&_table]:my-6 [&_table]:w-full [&_td]:border [&_td]:border-base-300 [&_td]:p-2 [&_th]:border [&_th]:border-base-300 [&_th]:bg-base-200 [&_th]:p-2 [&_th]:text-start [&_th]:font-semibold [&_ul]:my-4 [&_ul]:list-disc [&_ul]:space-y-2 [&_ul]:ps-6">
        {$static_page['page_text']}
      </div>
    </article>
    <!-- page text -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}
