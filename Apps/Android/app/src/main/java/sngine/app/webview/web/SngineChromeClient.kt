/**
 * SngineChromeClient
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import android.graphics.Bitmap
import android.net.Uri
import android.view.View
import android.webkit.GeolocationPermissions
import android.webkit.PermissionRequest
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebView
import androidx.core.graphics.createBitmap

/** Browser-chrome features: progress, uploads, permissions and full-screen video. */
class SngineChromeClient(private val listener: Listener) : WebChromeClient() {

    interface Listener {
        fun onProgress(progress: Int)
        fun onShowFileChooser(callback: ValueCallback<Array<Uri>>, params: FileChooserParams): Boolean
        fun onGeolocationRequest(origin: String, callback: GeolocationPermissions.Callback)
        fun onMediaPermissionRequest(request: PermissionRequest)
        fun onShowFullscreen(view: View, callback: CustomViewCallback)
        fun onHideFullscreen()
    }

    override fun onProgressChanged(view: WebView, newProgress: Int) = listener.onProgress(newProgress)

    override fun onShowFileChooser(
        webView: WebView,
        filePathCallback: ValueCallback<Array<Uri>>,
        fileChooserParams: FileChooserParams,
    ): Boolean = listener.onShowFileChooser(filePathCallback, fileChooserParams)

    override fun onGeolocationPermissionsShowPrompt(origin: String, callback: GeolocationPermissions.Callback) =
        listener.onGeolocationRequest(origin, callback)

    override fun onPermissionRequest(request: PermissionRequest) = listener.onMediaPermissionRequest(request)

    override fun onShowCustomView(view: View, callback: CustomViewCallback) =
        listener.onShowFullscreen(view, callback)

    override fun onHideCustomView() = listener.onHideFullscreen()

    /** Hides the grey "play" placeholder Chrome draws on videos before they load. */
    override fun getDefaultVideoPoster(): Bitmap = TRANSPARENT_POSTER

    private companion object {
        val TRANSPARENT_POSTER: Bitmap = createBitmap(1, 1)
    }
}
