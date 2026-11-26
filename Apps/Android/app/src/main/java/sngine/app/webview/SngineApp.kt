/**
 * SngineApp
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview

import android.app.Application
import android.webkit.WebView
import sngine.app.webview.push.PushNotifications

class SngineApp : Application() {

    val push by lazy { PushNotifications(this) }

    override fun onCreate() {
        super.onCreate()
        // Debug builds can be inspected from chrome://inspect on a computer.
        if (BuildConfig.DEBUG) WebView.setWebContentsDebuggingEnabled(true)
        push.init()
    }
}
