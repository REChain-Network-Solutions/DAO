/**
 * WebViewConfigurator
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.os.Build
import android.webkit.CookieManager
import android.webkit.DownloadListener
import android.webkit.WebSettings
import android.webkit.WebView
import androidx.core.content.getSystemService
import sngine.app.webview.SngineConfig

/** Applies the app's WebView settings in one place. */
object WebViewConfigurator {

    @SuppressLint("SetJavaScriptEnabled")
    fun configure(webView: WebView, downloads: DownloadListener) {
        webView.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            mediaPlaybackRequiresUserGesture = false
            cacheMode = WebSettings.LOAD_DEFAULT
            mixedContentMode = WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE
            allowFileAccess = false
            useWideViewPort = true
            loadWithOverviewMode = true
            setSupportZoom(SngineConfig.ENABLE_ZOOM)
            builtInZoomControls = SngineConfig.ENABLE_ZOOM
            displayZoomControls = false
            setGeolocationEnabled(SngineConfig.ENABLE_LOCATION)
            userAgentString = if (SngineConfig.APPEND_TO_DEFAULT_USER_AGENT) {
                "$userAgentString ${SngineConfig.USER_AGENT}"
            } else {
                SngineConfig.USER_AGENT
            }
            // Pre-render off-screen tiles for smoother scrolling, except on low-memory devices.
            offscreenPreRaster = webView.context.getSystemService<ActivityManager>()?.isLowRamDevice == false
        }

        webView.isVerticalScrollBarEnabled = false
        webView.setRendererPriorityPolicy(WebView.RENDERER_PRIORITY_IMPORTANT, true)
        webView.setDownloadListener(downloads)
        if (!SngineConfig.ENABLE_TEXT_SELECTION) {
            webView.setOnLongClickListener { true }
            webView.isHapticFeedbackEnabled = false
        }

        CookieManager.getInstance().apply {
            setAcceptCookie(true)
            setAcceptThirdPartyCookies(webView, true)
            setCookie(SngineConfig.SITE_URL, "DEVICE=android")
            setCookie(SngineConfig.SITE_URL, "DEV_API=${Build.VERSION.SDK_INT}")
        }
    }
}
