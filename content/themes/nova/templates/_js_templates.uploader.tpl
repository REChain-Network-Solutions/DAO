{*
  Shared client-side template — the file uploader row.

  Used by the .js_upload handlers in core.js. Included by both the frontend
  and AdminCP (14 admin templates upload files).
*}
    <script id="x-uploader" type="text/template">
      <form class="x-uploader" action="{literal}{{url}}{/literal}" method="post" enctype="multipart/form-data">
        {literal}{{#multiple}}{/literal}
        <input name="file[]" type="file" multiple="multiple" accept="{literal}{{accept}}{/literal}">
        {literal}{{/multiple}}{/literal}
        {literal}{{^multiple}}{/literal}
        <input name="file" type="file" accept="{literal}{{accept}}{/literal}">
        {literal}{{/multiple}}{/literal}
        <input type="hidden" name="secret" value="{literal}{{secret}}{/literal}">
      </form>
    </script>
