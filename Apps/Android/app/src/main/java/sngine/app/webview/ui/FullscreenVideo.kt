/**
 * FullscreenVideo
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.ui

import android.app.Activity
import android.content.pm.ActivityInfo
import android.view.View
import android.view.ViewGroup
import android.webkit.WebChromeClient.CustomViewCallback
import android.widget.FrameLayout
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.core.view.isVisible

/** Shows HTML5 video full screen (and lets it rotate to landscape). */
class FullscreenVideo(private val activity: Activity, private val container: FrameLayout) {

    private var view: View? = null
    private var callback: CustomViewCallback? = null
    private var previousOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED

    val isShowing: Boolean get() = view != null

    fun show(view: View, callback: CustomViewCallback) {
        if (isShowing) {
            callback.onCustomViewHidden()
            return
        }
        this.view = view
        this.callback = callback
        container.addView(view, FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
        container.isVisible = true
        previousOrientation = activity.requestedOrientation
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_FULL_USER
        insetsController().apply {
            systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
            hide(WindowInsetsCompat.Type.systemBars())
        }
    }

    fun hide() {
        val current = view ?: return
        container.removeView(current)
        container.isVisible = false
        activity.requestedOrientation = previousOrientation
        insetsController().show(WindowInsetsCompat.Type.systemBars())
        callback?.onCustomViewHidden()
        view = null
        callback = null
    }

    private fun insetsController() = WindowCompat.getInsetsController(activity.window, activity.window.decorView)
}
