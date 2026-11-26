<!doctype html>
<html data-lang="{$system['language']['code']}" {if $system['language']['dir'] == "RTL"} dir="RTL" {/if}>

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex">
    <title>{$page_title|truncate:70}</title>
    {include file='_head.fonts.tpl' _mono=false}
    <link rel="stylesheet" href="{$system['system_url']}/node_modules/plyr/dist/plyr.css" />
    <link rel="stylesheet" href="{$system['system_url']}/content/themes/{$system['theme']}/css/embed.css?v={$system['system_version']}" />
    <style>
      :root {
        --plyr-color-main: {if $system['css_btn_primary']}{$system['css_btn_primary']}{elseif $system['css_link_color']}{$system['css_link_color']}{else}#5e72e4{/if};
      }
    </style>
  </head>

  <body>
    <div class="embed-video-wrapper">
      {include file='__embed_video.tpl'}
    </div>
    <script src="{$system['system_url']}/node_modules/plyr/dist/plyr.min.js" defer></script>
    <script src="{$system['system_url']}/node_modules/hls.js/dist/hls.min.js" defer></script>
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        var video = document.querySelector('video.js_video-plyr');
        if (!video) {
          return;
        }
        var ratio = {if $system['fluid_videos_enabled']}null{else}'16:9'{/if};
        var controls = ['play', 'progress', 'current-time', 'mute', 'volume', 'captions', 'settings', 'pip', 'airplay', 'fullscreen'];
        if (window.innerWidth <= 768) {
          controls.splice(controls.indexOf('volume'), 1);
        }
        var player = new Plyr(video, {
          ratio: ratio,
          fullscreen: {
            iosNative: true
          },
          controls: controls,
          settings: ['captions', 'quality', 'speed', 'loop'],
          hideControls: true,
          storage: true
        });
        var source = video.querySelector('source');
        if (source && source.getAttribute('src') && source.getAttribute('src').endsWith('.m3u8')) {
          if (typeof Hls !== 'undefined' && Hls.isSupported()) {
            var hls = new Hls();
            hls.loadSource(source.getAttribute('src'));
            hls.attachMedia(video);
          } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
            video.src = source.getAttribute('src');
          }
        }
      });
    </script>
  </body>

</html>