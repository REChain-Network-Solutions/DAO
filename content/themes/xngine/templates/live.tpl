{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}

@media (max-width: 520px) {
	.main-wrapper {
        padding: 49px 0;
    }
    .x_side_create {
        display: none;
    }
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-12 w-100">
		<div class="bg-black h-100 live-stream-wrapper position-relative">
			<!-- live stream video -->
			<div class="live-stream-video position-relative h-100">

				<!-- live counter -->
				<div class="live-counter position-absolute text-center m-3 fw-medium small text-uppercase text-white d-flex align-items-center gap-2">
					<span class="status rounded-2 offline" id=js_live-counter-status>{__("Offline")}</span>
					<span class="number rounded-2">
						<span id="js_live-counter-number">0</span>
					</span>
				</div>
				<!-- live counter -->

				<!-- live recording -->
				{if $system['save_live_enabled']}
					<div class="live-recording position-absolute text-center mx-3 fw-medium small text-uppercase text-danger rounded-2" id="js_live-recording">
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="align-text-bottom"><path d="M3.25 12C3.25 7.16751 7.16751 3.25 12 3.25C16.8325 3.25 20.75 7.16751 20.75 12C20.75 16.8325 16.8325 20.75 12 20.75C7.16751 20.75 3.25 16.8325 3.25 12Z" fill="currentColor"></path></svg>{__("Recording")}
					</div>
				{/if}
				<!-- live recording -->

				<!-- live video -->
				<div class="live-video-player bg-black h-100 w-100" id="js_live-video"></div>
				<!-- live video -->
			</div>
			<!-- live stream video -->
			
			<div class="position-absolute w-100 bottom-0 pb-3 pb-md-4 pt-5 start-0 end-0 x_live_foot">
				<div>
					<!-- live comments -->
					<div class="live-comments x-hidden" id="live-comments">
						<ul class="js_scroller" data-slimScroll-height="100%"></ul>
					</div>
					<!-- live comments -->
					
					<!-- live status -->
					<div class="text-center ptb10 plr15 live-status rounded-3 w-100 m-auto info" id="js_live-status">
						<div class="mb5">
							<svg width="34" height="34" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path opacity="0.4" d="M13 3.25H7C3.58 3.25 2.25 4.58 2.25 8V16C2.25 18.3 3.5 20.75 7 20.75H13C16.42 20.75 17.75 19.42 17.75 16V8C17.75 4.58 16.42 3.25 13 3.25Z"/><path d="M11.5011 11.3811C12.5394 11.3811 13.3811 10.5394 13.3811 9.50109C13.3811 8.4628 12.5394 7.62109 11.5011 7.62109C10.4628 7.62109 9.62109 8.4628 9.62109 9.50109C9.62109 10.5394 10.4628 11.3811 11.5011 11.3811Z"/><path d="M21.6505 6.17157C21.2405 5.96157 20.3805 5.72157 19.2105 6.54157L17.7305 7.58157C17.7405 7.72157 17.7505 7.85157 17.7505 8.00157V16.0016C17.7505 16.1516 17.7305 16.2816 17.7305 16.4216L19.2105 17.4616C19.8305 17.9016 20.3705 18.0416 20.8005 18.0416C21.1705 18.0416 21.4605 17.9416 21.6505 17.8416C22.0605 17.6316 22.7505 17.0616 22.7505 15.6316V8.38157C22.7505 6.95157 22.0605 6.38157 21.6505 6.17157Z"/></svg>
						</div>
						{__("Getting the Camera and Mic permissions")}<span class="spinner-grow spinner-grow-sm ml10"></span>
					</div>
					<!-- live status -->
				</div>
				
				<hr class="opacity-25">
				
				<div class="d-flex align-items-center justify-content-center gap-3 flex-wrap">
					<!-- live stream buttons -->
					<div class="live-stream-buttons flex-0" id="js_live-stream-buttons">
						<!-- camera selection -->
						<span class="dropdown" id="camera-select-menu">
							<div class="btn roundeded-circle lh-1 btn-secondary mr10" data-bs-toggle="dropdown">
								<i class="fa-solid fa-camera-rotate fa-fw"></i>
							</div>
							<ul class="dropdown-menu">
							</ul>
						</span>
						<!-- camera selection -->
						<!-- mute/unmute mic -->
						<button class="btn roundeded-circle lh-1 btn-secondary mr10 d-none d-md-inline-flex js_mute-mic" id="mic-btn" disabled>
							<i class="fas fa-microphone fa-fw"></i>
						</button>
						<!-- mute/unmute mic -->
						<!-- mute/unmute cam -->
						<button class="btn roundeded-circle lh-1 btn-secondary mr10 d-none d-md-inline-flex js_mute-cam" id="cam-btn" disabled>
							<i class="fas fa-video fa-fw"></i>
						</button>
						<!-- mute/unmute cam -->
						<!-- share/unshare screen -->
						<button class="btn roundeded-circle lh-1 btn-secondary mr10 d-none d-md-inline-flex js_share-screen" id="screen-btn" disabled>
							<i class="fas fa-desktop fa-fw"></i>
						</button>
						<!-- share/unshare screen -->
						<!-- mute/unmute comments -->
						<button class="btn roundeded-circle lh-1 btn-secondary js_mute-comments" id="comments-btn" disabled>
							<i class="fas fa-comments fa-fw"></i>
						</button>
						<!-- mute/unmute comments -->
					</div>
					<!-- live stream buttons -->
					
					<span type="button" class="btn btn-danger flex-0 x-hidden" id="js_live-end">{__("End")}</span>
					<span type="button" class="btn btn-main flex-0 x-hidden" id="js_live-start" {if $page_id} data-node-id={$page_id} data-node='page' {/if}{if $group_id} data-node-id={$group_id} data-node='group' {/if}{if $event_id} data-node-id={$event_id} data-node='event' {/if}>{__("Go Live")}</span>
					
					{if !$page_id && $user->_data['can_receive_tip']}
						<span class="flex-0 x-hidden" id="js_live-tips">
							<div class="form-check text-white m-0">
								<input type="checkbox" class="form-check-input" name="tips_enabled" id="tips_enabled">
								<label class="form-check-label" for="tips_enabled">{__("Enable Tips")}</label>
							</div>
						</span>
					{/if}
					{if $can_be_for_subscriptions}
						<span class="flex-0 x-hidden" id="js_live-subscriptions">
							<div class="form-check text-white m-0">
								<input type="checkbox" class="form-check-input" name="for_subscriptions" id="for_subscriptions">
								<label class="form-check-label" for="for_subscriptions">{__("Subscribers Only")}</label>
							</div>
						</span>
					{/if}
					{if $can_be_paid}
						<span class="flex-0 x-hidden" id="js_live-paid">
							<div class="form-check text-white m-0">
								<input type="checkbox" class="form-check-input" name="is_paid" id="is_paid">
								<label class="form-check-label" for="is_paid">{__("Paid Live")}</label>
							</div>
							
						</span>
						
						<div class="form-group flex-0" data-bs-theme="dark">
							<input id="js_live-paid-price" name="post-price" class="form-control x-hidden" type="text" placeholder='{__("Price")}'>
						</div>
					{/if}
				</div>
			</div>
		</div>
    </div>
    <!-- content panel -->

</div>
<!-- page content -->

{include file='_footer.tpl'}