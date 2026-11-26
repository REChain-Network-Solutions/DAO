{strip}
    <!-- Admin Code Editor -->
    {if $view == "design"}
      <script>
        $(function() {
          var editors = [
            CodeMirror.fromTextArea(document.getElementById('custome_js_header'), {
              mode: "javascript",
              lineNumbers: true,
              readOnly: false
            }),
            CodeMirror.fromTextArea(document.getElementById('custome_js_footer'), {
              mode: "javascript",
              lineNumbers: true,
              readOnly: false
            })
          ];

          function refreshDesignEditors() {
            editors.forEach(function(editor) {
              editor.refresh();
            });
          }

          $('#CustomCode form').on('submit', function() {
            editors.forEach(function(editor) {
              editor.save();
            });
          });

          $('#design-tab-code').on('click', function() {
            setTimeout(refreshDesignEditors, 50);
          });
        });
      </script>
    {/if}
    {if $view == "themes" && ($sub_view == "add" || $sub_view == "edit")}
      <script>
        $(function() {
          var themeCssEditor = CodeMirror.fromTextArea(document.getElementById('custom-css'), {
            mode: "css",
            lineNumbers: true,
            readOnly: false
          });

          $('form.js_ajax-forms').on('submit', function() {
            themeCssEditor.save();
          });

          $('#theme-tab-css').on('click', function() {
            setTimeout(function() {
              themeCssEditor.refresh();
            }, 50);
          });
        });
      </script>
    {/if}
    {if $view == "settings" && $sub_view == "uploads"}
      <script>
        $(function() {
          $('.nav-tabs a').on('shown.bs.tab', function() {
            cm.refresh();
          });
          cm = CodeMirror.fromTextArea(document.getElementById('google_cloud_file'), {
            mode: "javascript",
            lineNumbers: true,
            readOnly: false
          });
        });
      </script>
    {/if}
    <!-- Admin Code Editor -->
{/strip}
