/**
 * Downloader
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import android.Manifest
import android.app.DownloadManager
import android.os.Build
import android.os.Environment
import android.webkit.CookieManager
import android.webkit.DownloadListener
import android.webkit.URLUtil
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.core.content.getSystemService
import androidx.core.net.toUri
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import sngine.app.webview.R

/** Saves files the website offers for download to the public Downloads folder. */
class Downloader(private val activity: ComponentActivity, private val permissions: Permissions) : DownloadListener {

    override fun onDownloadStart(
        url: String,
        userAgent: String,
        contentDisposition: String?,
        mimeType: String?,
        contentLength: Long,
    ) {
        // DownloadManager only understands http(s); blob: and data: URLs used to crash the app.
        if (!URLUtil.isNetworkUrl(url)) {
            toast(activity.getString(R.string.download_failed))
            return
        }
        activity.lifecycleScope.launch {
            // Android 9 and older need the storage permission to write to Downloads.
            val storage = Manifest.permission.WRITE_EXTERNAL_STORAGE
            if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P && storage !in permissions.request(storage)) {
                return@launch
            }
            enqueue(url, userAgent, contentDisposition, mimeType)
        }
    }

    private fun enqueue(url: String, userAgent: String, contentDisposition: String?, mimeType: String?) {
        val fileName = URLUtil.guessFileName(url, contentDisposition, mimeType)
        try {
            val request = DownloadManager.Request(url.toUri()).apply {
                setMimeType(mimeType)
                CookieManager.getInstance().getCookie(url)?.let { addRequestHeader("Cookie", it) }
                addRequestHeader("User-Agent", userAgent)
                setTitle(fileName)
                setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
                setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, fileName)
            }
            activity.getSystemService<DownloadManager>()!!.enqueue(request)
            toast(activity.getString(R.string.download_started, fileName))
        } catch (_: Exception) {
            toast(activity.getString(R.string.download_failed))
        }
    }

    private fun toast(message: String) = Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
}
