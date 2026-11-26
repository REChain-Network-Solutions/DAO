/**
 * SngineWebViewClient
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import android.graphics.Bitmap
import android.webkit.RenderProcessGoneDetail
import android.webkit.WebResourceError
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient

/**
 * Page lifecycle and navigation. SSL errors are not overridden: invalid certificates are always
 * rejected (Google Play blocks apps that ignore them).
 */
class SngineWebViewClient(
    private val router: UrlRouter,
    private val listener: Listener,
) : WebViewClient() {

    interface Listener {
        fun onPageStarted(url: String)
        fun onPageVisible(url: String)
        fun onPageFinished(url: String)
        fun onHistoryChanged(url: String)
        fun onMainFrameError()
        fun onUrlAction(view: WebView, action: UrlAction): Boolean
        fun onRendererGone(view: WebView)
    }

    override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
        val url = request.url.toString()
        // Sub-frames (embeds, ads) may only navigate to web content.
        if (!request.isForMainFrame) return UrlRouter.schemeOf(url) !in UrlRouter.WEB_SCHEMES
        return listener.onUrlAction(view, router.route(url))
    }

    override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) = listener.onPageStarted(url)

    override fun onPageCommitVisible(view: WebView, url: String) = listener.onPageVisible(url)

    override fun onPageFinished(view: WebView, url: String) = listener.onPageFinished(url)

    override fun doUpdateVisitedHistory(view: WebView, url: String, isReload: Boolean) =
        listener.onHistoryChanged(url)

    override fun onReceivedError(view: WebView, request: WebResourceRequest, error: WebResourceError) {
        // A failed image or script must not replace the whole page.
        if (request.isForMainFrame) listener.onMainFrameError()
    }

    override fun onRenderProcessGone(view: WebView, detail: RenderProcessGoneDetail): Boolean {
        listener.onRendererGone(view)
        return true
    }
}
