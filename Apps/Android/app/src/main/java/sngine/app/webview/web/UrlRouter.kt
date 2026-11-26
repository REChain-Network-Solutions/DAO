/**
 * UrlRouter
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import java.net.URI

/** What to do with a URL the website navigates to. */
sealed interface UrlAction {
    /** Let the WebView load it normally. */
    data object Default : UrlAction

    /** Load a rewritten URL inside the app. */
    data class Load(val url: String) : UrlAction

    /** Reload the current page, or go back to the home page. */
    data class Reload(val home: Boolean) : UrlAction

    /** Hand the URL to another app (browser, dialer, mail, WhatsApp…). */
    data class OpenExternally(val url: String) : UrlAction

    /** An Android `intent://` link. */
    data class OpenIntent(val url: String) : UrlAction

    /** `share:<url>` — open the system share sheet. */
    data class Share(val url: String) : UrlAction

    /** `rate:` — open the app's Play Store page. */
    data object RateApp : UrlAction

    /** `exit:` — leave the app. */
    data object Exit : UrlAction
}

/**
 * Decides how main-frame navigations are handled. Pure Kotlin so it can be unit tested.
 *
 * Supported special links (use them as `href` on your website):
 * `refresh:` / `refresh:URL`, `share:<url>`, `rate:android`, `exit:android`, `<scheme>://host/path`.
 */
class UrlRouter(
    siteUrl: String,
    private val deepLinkScheme: String,
    private val openExternalLinksInBrowser: Boolean,
) {
    private val siteHost: String? = hostOf(siteUrl)

    fun route(url: String): UrlAction = when (schemeOf(url)) {
        deepLinkScheme -> deepLinkToHttps(url)?.let(UrlAction::Load) ?: UrlAction.OpenExternally(url)
        "refresh" -> UrlAction.Reload(home = url.substringAfter(':').equals("URL", ignoreCase = true))
        "share" -> UrlAction.Share(url.substringAfter(':'))
        "rate" -> UrlAction.RateApp
        "exit" -> UrlAction.Exit
        "intent" -> UrlAction.OpenIntent(url)
        "http", "https" ->
            if (openExternalLinksInBrowser && !isInternal(url)) UrlAction.OpenExternally(url) else UrlAction.Default
        in WEB_SCHEMES -> UrlAction.Default
        else -> UrlAction.OpenExternally(url)
    }

    /** `sngine://example.com/path` → `https://example.com/path`, only for this website's host. */
    fun deepLinkToHttps(url: String): String? {
        if (schemeOf(url) != deepLinkScheme) return null
        val https = "https://" + url.substringAfter("://")
        return https.takeIf(::isInternal)
    }

    /** True when the URL points at this website or one of its subdomains. */
    fun isInternal(url: String): Boolean {
        val host = hostOf(url) ?: return false
        val site = siteHost ?: return false
        return host == site || host.endsWith(".$site")
    }

    companion object {
        /** Schemes the WebView handles itself. */
        val WEB_SCHEMES = setOf("http", "https", "about", "data", "blob", "javascript", "file", "")

        fun schemeOf(url: String): String =
            url.substringBefore(':', missingDelimiterValue = "").trim().lowercase()

        fun hostOf(url: String): String? =
            runCatching { URI(url.trim()).host?.lowercase()?.removePrefix("www.") }.getOrNull()
    }
}
