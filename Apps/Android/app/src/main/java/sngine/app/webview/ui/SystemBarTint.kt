/**
 * SystemBarTint
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.ui

import android.app.Activity
import android.graphics.Rect
import android.os.Handler
import android.os.Looper
import android.view.PixelCopy
import android.view.View
import androidx.core.graphics.ColorUtils
import androidx.core.graphics.createBitmap
import androidx.core.graphics.get
import androidx.core.graphics.scale
import androidx.core.view.WindowCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import sngine.app.webview.SngineConfig
import kotlin.coroutines.resume

/**
 * Colors the areas behind the status bar and navigation bar like the page's own top and bottom rows
 * (the way Safari tints its bars), and picks light or dark bar icons so they stay readable.
 */
class SystemBarTint(
    private val activity: Activity,
    private val statusBarFill: View,
    private val navigationBarFill: View,
    private val page: View,
    private val scope: CoroutineScope,
) {
    private var job: Job? = null
    private val insetsController get() = WindowCompat.getInsetsController(activity.window, activity.window.decorView)

    /** Re-samples the page edges shortly after the page changes or scrolls (debounced). */
    fun update() {
        if (!SngineConfig.SYSTEM_BARS_FOLLOW_PAGE) return
        job?.cancel()
        job = scope.launch {
            delay(DEBOUNCE_MS)
            val bounds = pageBoundsInWindow() ?: return@launch
            // Skip the thin progress bar at the very top of the page.
            val offset = (TOP_OFFSET_DP * activity.resources.displayMetrics.density).toInt()

            sample(Rect(bounds.left, bounds.top + offset, bounds.right, bounds.top + offset + ROWS))?.let { color ->
                statusBarFill.setBackgroundColor(color)
                insetsController.isAppearanceLightStatusBars = !isDark(color)
            }
            sample(Rect(bounds.left, bounds.bottom - ROWS, bounds.right, bounds.bottom))?.let { color ->
                navigationBarFill.setBackgroundColor(color)
                insetsController.isAppearanceLightNavigationBars = !isDark(color)
            }
        }
    }

    private fun pageBoundsInWindow(): Rect? {
        if (page.width == 0 || page.height == 0) return null
        val location = IntArray(2).also(page::getLocationInWindow)
        return Rect(location[0], location[1], location[0] + page.width, location[1] + page.height)
    }

    /** Copies a few rows of what's on screen and returns their average color, or null if it can't. */
    private suspend fun sample(rect: Rect): Int? = suspendCancellableCoroutine { continuation ->
        val bitmap = createBitmap(rect.width(), rect.height())
        try {
            PixelCopy.request(activity.window, rect, bitmap, { result ->
                val color = if (result == PixelCopy.SUCCESS) bitmap.scale(1, 1)[0, 0] else null
                bitmap.recycle()
                if (continuation.isActive) continuation.resume(color)
            }, Handler(Looper.getMainLooper()))
        } catch (_: IllegalArgumentException) {
            bitmap.recycle()
            continuation.resume(null) // Window not ready yet.
        }
    }

    private fun isDark(color: Int) = ColorUtils.calculateLuminance(color) < 0.5

    private companion object {
        const val DEBOUNCE_MS = 300L
        const val TOP_OFFSET_DP = 4
        const val ROWS = 4
    }
}
