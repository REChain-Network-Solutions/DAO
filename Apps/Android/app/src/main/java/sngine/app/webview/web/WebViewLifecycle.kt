/**
 * WebViewLifecycle
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import android.view.ViewGroup
import android.webkit.CookieManager
import android.webkit.WebView
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import sngine.app.webview.SngineConfig

/** Pauses the WebView in the background, persists cookies and destroys it with the activity. */
class WebViewLifecycle(private val webView: () -> WebView) : DefaultLifecycleObserver {

    override fun onStart(owner: LifecycleOwner) {
        webView().onResume()
        if (SngineConfig.PAUSE_IN_BACKGROUND) webView().resumeTimers()
    }

    override fun onStop(owner: LifecycleOwner) {
        webView().onPause()
        if (SngineConfig.PAUSE_IN_BACKGROUND) webView().pauseTimers()
        // Keep the login session if the system kills the app in the background.
        owner.lifecycleScope.launch(Dispatchers.IO) { CookieManager.getInstance().flush() }
    }

    override fun onDestroy(owner: LifecycleOwner) {
        webView().apply {
            (parent as? ViewGroup)?.removeView(this)
            destroy()
        }
    }
}
