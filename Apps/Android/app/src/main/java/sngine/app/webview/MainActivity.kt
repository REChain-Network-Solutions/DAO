/**
 * MainActivity
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview

import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.ActivityInfo
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.os.SystemClock
import android.view.View
import android.view.ViewGroup
import android.webkit.GeolocationPermissions
import android.webkit.PermissionRequest
import android.webkit.URLUtil
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebView
import androidx.activity.OnBackPressedCallback
import androidx.activity.SystemBarStyle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.splashscreen.SplashScreen
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.updateLayoutParams
import androidx.core.view.updatePadding
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.lifecycle.withResumed
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.launch
import org.json.JSONObject
import sngine.app.webview.databinding.ActivityMainBinding
import sngine.app.webview.feature.Connectivity
import sngine.app.webview.feature.Downloader
import sngine.app.webview.feature.FileChooser
import sngine.app.webview.feature.LocationHelper
import sngine.app.webview.feature.Permissions
import sngine.app.webview.feature.ReviewPrompt
import sngine.app.webview.ui.FullscreenVideo
import sngine.app.webview.ui.OfflineView
import sngine.app.webview.ui.SystemBarTint
import sngine.app.webview.web.SngineChromeClient
import sngine.app.webview.web.SngineWebViewClient
import sngine.app.webview.web.UrlAction
import sngine.app.webview.web.UrlActionHandler
import sngine.app.webview.web.UrlRouter
import sngine.app.webview.web.WebViewConfigurator
import sngine.app.webview.web.WebViewLifecycle

/** The single screen of the app: the website, plus native splash, offline screen and full-screen video. */
class MainActivity : AppCompatActivity(), SngineWebViewClient.Listener, SngineChromeClient.Listener {

    private lateinit var binding: ActivityMainBinding
    private lateinit var webView: WebView
    private lateinit var offline: OfflineView
    private lateinit var fullscreen: FullscreenVideo
    private lateinit var barTint: SystemBarTint

    private val permissions = Permissions(this) { binding.root }
    private val fileChooser = FileChooser(this, permissions)
    private val location = LocationHelper(this, permissions)
    private val downloader = Downloader(this, permissions)
    private val connectivity by lazy { Connectivity(this) }
    private val reviewPrompt by lazy { ReviewPrompt(this) }
    private val push get() = (application as SngineApp).push
    private val urlActions = UrlActionHandler(this)
    private val router = UrlRouter(
        siteUrl = SngineConfig.SITE_URL,
        deepLinkScheme = SngineConfig.DEEP_LINK_SCHEME,
        openExternalLinksInBrowser = SngineConfig.OPEN_EXTERNAL_LINKS_IN_BROWSER,
    )

    private var firstPageShown = false
    private var pullToRefreshAllowed = true

    private val backCallback = object : OnBackPressedCallback(false) {
        override fun handleOnBackPressed() = if (fullscreen.isShowing) fullscreen.hide() else webView.goBack()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        val splash = installSplashScreen()
        super.onCreate(savedInstanceState)
        setUpWindow()
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        holdSplashUntilPageVisible(splash)
        applyWindowInsets()

        offline = OfflineView(binding.offline, ::retry)
        fullscreen = FullscreenVideo(this, binding.fullscreenContainer)
        barTint = SystemBarTint(this, binding.statusBarFill, binding.navigationBarFill, binding.swipeRefresh, lifecycleScope)
        setUpPullToRefresh()
        webView = createWebView()
        lifecycle.addObserver(WebViewLifecycle { webView })
        onBackPressedDispatcher.addCallback(this, backCallback)

        // Start loading right away so the network work happens behind the splash screen.
        val restored = savedInstanceState?.let(webView::restoreState) != null
        if (!restored) webView.loadUrl(urlFromIntent(intent) ?: SngineConfig.SITE_URL)
        if (savedInstanceState == null) lifecycleScope.launch(Dispatchers.IO) { reviewPrompt.recordLaunch() }

        observeConnectivity()
        observePushSubscription()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        urlFromIntent(intent)?.let(webView::loadUrl)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        webView.saveState(outState)
    }

    /* ── Setup ───────────────────────────────────────────────── */

    @SuppressLint("SourceLockedOrientationActivity")
    private fun setUpWindow() {
        val style = if (resources.getBoolean(R.bool.light_system_bars)) {
            SystemBarStyle.light(Color.TRANSPARENT, Color.TRANSPARENT)
        } else {
            SystemBarStyle.dark(Color.TRANSPARENT)
        }
        enableEdgeToEdge(style, style)
        // Tablets and foldables keep free rotation.
        if (SngineConfig.LOCK_PORTRAIT && resources.configuration.smallestScreenWidthDp < 600) {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        }
    }

    private fun holdSplashUntilPageVisible(splash: SplashScreen) {
        val start = SystemClock.uptimeMillis()
        splash.setKeepOnScreenCondition {
            !firstPageShown && SystemClock.uptimeMillis() - start < SngineConfig.SPLASH_MAX_DURATION_MS
        }
        splash.setOnExitAnimationListener { provider ->
            provider.view.animate().alpha(0f).setDuration(SPLASH_FADE_MS).withEndAction(provider::remove).start()
        }
    }

    /** Keeps the website clear of the status bar, navigation bar, camera cutout and keyboard. */
    private fun applyWindowInsets() {
        ViewCompat.setOnApplyWindowInsetsListener(binding.content) { view, insets ->
            val bars = insets.getInsets(WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout())
            val keyboard = insets.getInsets(WindowInsetsCompat.Type.ime())
            val bottom = maxOf(bars.bottom, keyboard.bottom)
            view.updatePadding(bars.left, bars.top, bars.right, bottom)
            binding.statusBarFill.updateLayoutParams { height = bars.top }
            binding.navigationBarFill.updateLayoutParams { height = bottom }
            WindowInsetsCompat.CONSUMED
        }
    }

    private fun setUpPullToRefresh() = binding.swipeRefresh.run {
        isEnabled = SngineConfig.ENABLE_PULL_TO_REFRESH
        setColorSchemeColors(getColor(R.color.brand_primary))
        setOnChildScrollUpCallback { _, _ -> !pullToRefreshAllowed || webView.canScrollVertically(-1) }
        setOnRefreshListener { webView.reload() }
    }

    private fun createWebView(): WebView = WebView(this).apply {
        setBackgroundColor(getColor(R.color.page_background))
        WebViewConfigurator.configure(this, downloader)
        webViewClient = SngineWebViewClient(router, this@MainActivity)
        webChromeClient = SngineChromeClient(this@MainActivity)
        setOnScrollChangeListener { _, _, _, _, _ -> barTint.update() }
        binding.swipeRefresh.addView(
            this,
            ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT),
        )
    }

    private fun observeConnectivity() = lifecycleScope.launch {
        repeatOnLifecycle(Lifecycle.State.STARTED) {
            connectivity.changes().collect { online -> if (online && offline.isShowing) retry() }
        }
    }

    private fun observePushSubscription() = lifecycleScope.launch {
        repeatOnLifecycle(Lifecycle.State.STARTED) {
            push.subscriptionId.filterNotNull().collect { sendPushIdToWebsite() }
        }
    }

    /* ── Page events ─────────────────────────────────────────── */

    override fun onPageStarted(url: String) {
        offline.hide()
        updatePullToRefresh(url)
    }

    override fun onPageVisible(url: String) {
        binding.swipeRefresh.isRefreshing = false
        barTint.update()
        onFirstPageShown()
    }

    override fun onPageFinished(url: String) {
        binding.swipeRefresh.isRefreshing = false
        barTint.update()
        sendPushIdToWebsite()
    }

    override fun onHistoryChanged(url: String) {
        updatePullToRefresh(url)
        updateBackCallback()
        barTint.update()
    }

    override fun onMainFrameError() {
        binding.swipeRefresh.isRefreshing = false
        offline.show(online = connectivity.isOnline)
        barTint.update()
        onFirstPageShown()
    }

    override fun onUrlAction(view: WebView, action: UrlAction): Boolean = urlActions.handle(view, action)

    /** Chrome killed the page renderer (usually low memory): rebuild the WebView instead of crashing. */
    override fun onRendererGone(view: WebView) {
        val url = view.url ?: SngineConfig.SITE_URL
        binding.swipeRefresh.removeView(view)
        view.destroy()
        webView = createWebView()
        webView.loadUrl(url)
    }

    /* ── Browser features ────────────────────────────────────── */

    override fun onProgress(progress: Int) {
        if (!SngineConfig.SHOW_PROGRESS_BAR) return
        if (progress < 100) {
            binding.progress.show()
            binding.progress.setProgressCompat(progress, true)
        } else {
            binding.progress.hide()
        }
    }

    override fun onShowFileChooser(
        callback: ValueCallback<Array<Uri>>,
        params: WebChromeClient.FileChooserParams,
    ): Boolean = fileChooser.show(callback, params)

    override fun onGeolocationRequest(origin: String, callback: GeolocationPermissions.Callback) {
        lifecycleScope.launch {
            val allowed = location.ensureReady()
            callback.invoke(origin, allowed, false)
            if (allowed) location.updateCookies()
        }
    }

    /** Camera / microphone for the website (calls, live video), granted only after the user allows it. */
    override fun onMediaPermissionRequest(request: PermissionRequest) {
        if (!router.isInternal(request.origin.toString())) return request.deny()
        val needs = mapOf(
            PermissionRequest.RESOURCE_VIDEO_CAPTURE to Manifest.permission.CAMERA,
            PermissionRequest.RESOURCE_AUDIO_CAPTURE to Manifest.permission.RECORD_AUDIO,
        ).filterKeys { it in request.resources }
        val protectedMedia = request.resources.filter { it == PermissionRequest.RESOURCE_PROTECTED_MEDIA_ID }

        lifecycleScope.launch {
            val granted = permissions.request(*needs.values.toTypedArray())
            val allowed = needs.filterValues { it in granted }.keys + protectedMedia
            if (allowed.isEmpty()) request.deny() else request.grant(allowed.toTypedArray())
        }
    }

    override fun onShowFullscreen(view: View, callback: WebChromeClient.CustomViewCallback) {
        fullscreen.show(view, callback)
        updateBackCallback()
    }

    override fun onHideFullscreen() {
        fullscreen.hide()
        updateBackCallback()
    }

    /* ── Helpers ─────────────────────────────────────────────── */

    private fun retry() {
        offline.hide()
        if (webView.url == null) webView.loadUrl(SngineConfig.SITE_URL) else webView.reload()
    }

    /** Runs once, after the splash screen is gone: ask for permissions and schedule the rating prompt. */
    private fun onFirstPageShown() {
        if (firstPageShown) return
        firstPageShown = true
        lifecycleScope.launch {
            if (SngineConfig.ASK_LOCATION_ON_LAUNCH) location.ensureReady()
            location.updateCookies()
            push.requestPermission()
        }
        lifecycleScope.launch {
            delay(RATING_DELAY_MS)
            lifecycle.withResumed { }
            reviewPrompt.maybeAsk(this@MainActivity)
        }
    }

    private fun updatePullToRefresh(url: String) {
        pullToRefreshAllowed = SngineConfig.PULL_TO_REFRESH_DISABLED_ON.none { url.contains(it) }
    }

    private fun updateBackCallback() {
        backCallback.isEnabled = fullscreen.isShowing || webView.canGoBack()
    }

    /** Lets Sngine link this device to the logged-in user for push notifications. */
    private fun sendPushIdToWebsite() {
        val id = push.subscriptionId.value ?: return
        if (!router.isInternal(webView.url ?: return)) return
        webView.evaluateJavascript(
            "if (typeof saveAndroidOneSignalUserId === 'function') saveAndroidOneSignalUserId(${JSONObject.quote(id)});",
            null,
        )
    }

    /** Deep link (`sngine://…`), website link or notification URL that opened the app. */
    private fun urlFromIntent(intent: Intent?): String? {
        val url = intent?.dataString ?: return null
        return router.deepLinkToHttps(url) ?: url.takeIf { URLUtil.isNetworkUrl(it) && router.isInternal(it) }
    }

    private companion object {
        const val SPLASH_FADE_MS = 250L
        const val RATING_DELAY_MS = 60_000L
    }
}
