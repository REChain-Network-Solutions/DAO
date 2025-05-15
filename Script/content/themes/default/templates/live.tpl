{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- side panel -->
    <div class="col-12 d-block d-md-none sg-offcanvas-sidebar">
      {include file='_sidebar.tpl'}
    </div>
    <!-- side panel -->

    <!-- content panel -->
    <div class="col-12 sg-offcanvas-mainbar">

      <div class="live-stream-wrapper">

        <!-- live stream title -->
        <div class="live-stream-title clearfix">
          {include file='__svg_icons.tpl' icon="live" class="main-icon" width="40px" height="40px"}
          {__("Live")}
          <div class="float-end">
            {if !$page_id && $user->_data['can_receive_tip']}
              <span class="x-hidden" id="js_live-tips">
                <input type="checkbox" class="btn-check" name="tips_enabled" id="tips_enabled">
                <label class="btn btn-md btn-outline-info rounded-pill" for="tips_enabled"> {__("Enable Tips")}</label>
              </span>
            {/if}
            {if $can_be_for_subscriptions}
              <span class="x-hidden" id="js_live-subscriptions">
                <input type="checkbox" class="btn-check" name="for_subscriptions" id="for_subscriptions">
                <label class="btn btn-md btn-outline-info rounded-pill" for="for_subscriptions"> {__("Subscribers Only")}</label>
              </span>
            {/if}
            {if $can_be_paid}
              <span class="x-hidden" id="js_live-paid">
                <input type="checkbox" class="btn-check" name="is_paid" id="is_paid">
                <label class="btn btn-md btn-outline-info rounded-pill" for="is_paid"> {__("Paid Live")}</label>
                <input id="js_live-paid-price" name="post-price" class="x-hidden rounded-pill" style="padding: 0px 20px; background: rgb(30 37 43); border: 1px solid rgb(13 202 240); font-size: 16px; line-height: 42px; outline: none; color: rgb(255, 255, 255); min-width: 80px; vertical-align: middle;" type="text" placeholder="{__("Price")}">
              </span>
            {/if}
            <span class="btn btn-md btn-danger rounded-pill x-hidden" id="js_live-end"><i class="fas fa-power-off mr5"></i>{__("End")}</span>
            <span class="btn btn-md btn-danger rounded-pill x-hidden" id="js_live-start" {if $page_id} data-node-id={$page_id} data-node='page' {/if}{if $group_id} data-node-id={$group_id} data-node='group' {/if}{if $event_id} data-node-id={$event_id} data-node='event' {/if}><i class="fas fa-play mr5"></i>{__("Go Live")}</span>
          </div>
        </div>
        <!-- live stream title -->

        <!-- live stream video -->
        <div class="live-stream-video">

          <!-- live counter -->
          <div class="live-counter">
            <span class="status offline" id=js_live-counter-status>{__("Offline")}</span>
            <span class="number">
              <i class="fas fa-eye mr5"></i><strong id="js_live-counter-number">0</strong>
            </span>
          </div>
          <!-- live counter -->

          <!-- live recording -->
          {if $system['save_live_enabled']}
            <div class="live-recording" id="js_live-recording">
              <span>
                <i class="fas fa-record-vinyl mr5"></i><span>{__("Recording")}</span>
              </span>
            </div>
          {/if}
          <!-- live recording -->

          <!-- live status -->
          <div class="live-status" id="js_live-status">
            <div class="mb5"><i class="fas fa-camera fa-2x"></i></div>
            {__("Getting the Camera and Mic permissions")}<span class="spinner-grow spinner-grow-sm ml10"></span>
          </div>
          <!-- live status -->

          <!-- live comments -->
          <div class="live-comments x-hidden" id="live-comments">
            <ul class="js_scroller" data-slimScroll-height="100%"></ul>
          </div>
          <!-- live comments -->

          <!-- live video -->
          <div class="live-video-player" id="js_live-video"></div>
          <!-- live video -->
        </div>
        <!-- live stream video -->

        <!-- live stream buttons -->
        <div class="live-stream-buttons" id="js_live-stream-buttons">
          <!-- camera selection -->
          <span class="dropdown" id="camera-select-menu">
            <div class="btn btn-md btn-icon btn-rounded btn-secondary mr10" data-bs-toggle="dropdown">
              <i class="fa-solid fa-lg fa-camera-rotate fa-fw"></i>
            </div>
            <ul class="dropdown-menu">
            </ul>
          </span>
          <!-- camera selection -->
          <!-- mute/unmute mic -->
          <button class="btn btn-md btn-icon btn-rounded btn-secondary mr10 d-none d-sm-none d-md-inline js_mute-mic" id="mic-btn" disabled>
            <i class="fas fa-lg fa-microphone fa-fw"></i>
          </button>
          <!-- mute/unmute mic -->
          <!-- mute/unmute cam -->
          <button class="btn btn-md btn-icon btn-rounded btn-secondary mr10 d-none d-sm-none d-md-inline js_mute-cam" id="cam-btn" disabled>
            <i class="fas fa-lg fa-video fa-fw"></i>
          </button>
          <!-- mute/unmute cam -->
          <!-- share/unshare screen -->
          <button class="btn btn-md btn-icon btn-rounded btn-secondary mr10 d-none d-sm-none d-md-inline js_share-screen" id="screen-btn" disabled>
            <i class="fas fa-lg fa-desktop fa-fw"></i>
          </button>
          <!-- share/unshare screen -->
          <!-- mute/unmute comments -->
          <button class="btn btn-md btn-icon btn-rounded btn-secondary mr10 js_mute-comments" id="comments-btn" disabled>
            <i class="fas fa-lg fa-comments fa-fw"></i>
          </button>
          <!-- mute/unmute comments -->
        </div>
        <!-- live stream buttons -->

      </div>

    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}