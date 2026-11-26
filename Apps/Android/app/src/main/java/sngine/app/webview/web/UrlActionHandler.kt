/**
 * UrlActionHandler
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.webkit.WebView
import android.widget.Toast
import androidx.core.net.toUri
import sngine.app.webview.R
import sngine.app.webview.SngineConfig

/** Performs a [UrlAction] on behalf of the activity. Returns true when the WebView should not load the URL. */
class UrlActionHandler(private val activity: Activity) {

    fun handle(webView: WebView, action: UrlAction): Boolean {
        when (action) {
            UrlAction.Default -> return false
            is UrlAction.Load -> webView.loadUrl(action.url)
            is UrlAction.Reload -> if (action.home) webView.loadUrl(SngineConfig.SITE_URL) else webView.reload()
            is UrlAction.OpenExternally -> openExternally(action.url)
            is UrlAction.OpenIntent -> openIntent(webView, action.url)
            is UrlAction.Share -> share(webView.title, action.url)
            UrlAction.RateApp -> rateApp()
            UrlAction.Exit -> activity.moveTaskToBack(true)
        }
        return true
    }

    fun openExternally(url: String) {
        val intent = Intent(Intent.ACTION_VIEW, url.toUri()).addCategory(Intent.CATEGORY_BROWSABLE)
        start(intent)
    }

    private fun openIntent(webView: WebView, url: String) {
        val intent = runCatching { Intent.parseUri(url, Intent.URI_INTENT_SCHEME) }.getOrNull() ?: return
        // Never let a web page start private components of other apps.
        intent.addCategory(Intent.CATEGORY_BROWSABLE)
        intent.component = null
        intent.selector = null
        try {
            activity.startActivity(intent)
        } catch (_: ActivityNotFoundException) {
            val fallback = intent.getStringExtra("browser_fallback_url")
                ?.takeIf { UrlRouter.schemeOf(it) == "http" || UrlRouter.schemeOf(it) == "https" }
            val appPackage = intent.`package`
            when {
                fallback != null -> webView.loadUrl(fallback)
                appPackage != null -> openStore(appPackage)
                else -> toast(R.string.no_app_for_link)
            }
        }
    }

    private fun share(title: String?, url: String) {
        val text = listOfNotNull(title, activity.getString(R.string.share_visit, url)).joinToString("\n")
        val send = Intent(Intent.ACTION_SEND)
            .setType("text/plain")
            .putExtra(Intent.EXTRA_SUBJECT, title)
            .putExtra(Intent.EXTRA_TEXT, text)
        start(Intent.createChooser(send, activity.getString(R.string.share_via)))
    }

    private fun rateApp() = openStore(activity.packageName)

    private fun openStore(packageName: String) {
        try {
            activity.startActivity(Intent(Intent.ACTION_VIEW, "market://details?id=$packageName".toUri()))
        } catch (_: ActivityNotFoundException) {
            openExternally("https://play.google.com/store/apps/details?id=$packageName")
        }
    }

    private fun start(intent: Intent) {
        try {
            activity.startActivity(intent)
        } catch (_: ActivityNotFoundException) {
            toast(R.string.no_app_for_link)
        }
    }

    private fun toast(message: Int) = Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
}
