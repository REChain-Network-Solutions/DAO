/**
 * FileChooser
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import android.Manifest
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import android.webkit.ValueCallback
import android.webkit.WebChromeClient.FileChooserParams
import androidx.activity.ComponentActivity
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.result.contract.ActivityResultContracts.PickVisualMedia
import androidx.core.content.FileProvider
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.withCreated
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import sngine.app.webview.R
import sngine.app.webview.SngineConfig
import java.io.File
import java.util.concurrent.TimeUnit

/**
 * Handles `<input type="file">`: Android Photo Picker for media, the document picker for other
 * files, and the camera through a FileProvider `content://` URI.
 *
 * Every request completes the WebView callback exactly once (with `null` on cancel), and an
 * empty camera file is never returned — the cause of the old "This file is empty" (0 B) uploads.
 * Must be created before the activity is started (e.g. as a property).
 */
class FileChooser(private val activity: ComponentActivity, private val permissions: Permissions) {

    private var callback: ValueCallback<Array<Uri>>? = null
    private var captureFile: File? = null
    private val captureDir get() = File(activity.cacheDir, "camera")

    private val pickOne = activity.registerForActivityResult(PickVisualMedia()) { deliver(listOfNotNull(it)) }
    private val pickMany = activity.registerForActivityResult(ActivityResultContracts.PickMultipleVisualMedia()) {
        deliver(it)
    }
    private val openOne = activity.registerForActivityResult(ActivityResultContracts.OpenDocument()) {
        deliver(listOfNotNull(it))
    }
    private val openMany = activity.registerForActivityResult(ActivityResultContracts.OpenMultipleDocuments()) {
        deliver(it)
    }
    private val takePicture = activity.registerForActivityResult(ActivityResultContracts.TakePicture(), ::onCaptured)
    private val captureVideo = activity.registerForActivityResult(ActivityResultContracts.CaptureVideo(), ::onCaptured)

    init {
        activity.lifecycleScope.launch {
            activity.lifecycle.withCreated { } // The activity has no context until it is created.
            withContext(Dispatchers.IO) { deleteOldCaptures() }
        }
    }

    /** Called from `WebChromeClient.onShowFileChooser`. */
    fun show(callback: ValueCallback<Array<Uri>>, params: FileChooserParams): Boolean {
        if (!SngineConfig.ENABLE_FILE_UPLOAD) return false
        deliver(emptyList()) // Finish any request that is still open.
        this.callback = callback

        val mimeTypes = normalise(params.acceptTypes)
        val kind = MediaKind.of(mimeTypes)
        val multiple = params.mode == FileChooserParams.MODE_OPEN_MULTIPLE
        val sources = UploadOptions.sources(
            kind = kind,
            cameraEnabled = SngineConfig.ENABLE_CAMERA_UPLOAD,
            cameraAvailable = hasCameraApp(),
            cameraOnly = SngineConfig.CAMERA_ONLY,
            captureRequested = params.isCaptureEnabled,
        )

        if (sources.size == 1) {
            launch(sources.single(), kind, mimeTypes, multiple)
        } else {
            val labels = sources.map { activity.getString(it.label) }.toTypedArray()
            MaterialAlertDialogBuilder(activity)
                .setTitle(R.string.upload_title)
                .setItems(labels) { _, which -> launch(sources[which], kind, mimeTypes, multiple) }
                .setOnCancelListener { deliver(emptyList()) }
                .show()
        }
        return true
    }

    private fun launch(source: UploadSource, kind: MediaKind, mimeTypes: List<String>, multiple: Boolean) {
        try {
            when (source) {
                UploadSource.Gallery -> {
                    val request = PickVisualMediaRequest(mediaType(kind))
                    if (multiple) pickMany.launch(request) else pickOne.launch(request)
                }
                UploadSource.Files -> {
                    val types = mimeTypes.ifEmpty { listOf("*/*") }.toTypedArray()
                    if (multiple) openMany.launch(types) else openOne.launch(types)
                }
                UploadSource.TakePhoto -> capture(".jpg") { takePicture.launch(it) }
                UploadSource.RecordVideo -> capture(".mp4") { captureVideo.launch(it) }
            }
        } catch (_: ActivityNotFoundException) {
            deliver(emptyList())
        }
    }

    /** Creates the output file off the main thread, asks for the camera permission, then opens the camera. */
    private fun capture(extension: String, open: (Uri) -> Unit) = activity.lifecycleScope.launch {
        if (Manifest.permission.CAMERA !in permissions.request(Manifest.permission.CAMERA)) {
            deliver(emptyList())
            return@launch
        }
        val file = withContext(Dispatchers.IO) {
            captureDir.mkdirs()
            File.createTempFile("capture_", extension, captureDir)
        }
        captureFile = file
        try {
            open(FileProvider.getUriForFile(activity, "${activity.packageName}.fileprovider", file))
        } catch (_: ActivityNotFoundException) {
            onCaptured(false)
        }
    }

    private fun onCaptured(success: Boolean) {
        val file = captureFile ?: return deliver(emptyList())
        captureFile = null
        if (UploadOptions.isCaptureUsable(success, file.length())) {
            deliver(listOf(FileProvider.getUriForFile(activity, "${activity.packageName}.fileprovider", file)))
        } else {
            file.delete()
            deliver(emptyList())
        }
    }

    private fun deliver(uris: List<Uri>) {
        val pending = callback ?: return
        callback = null
        pending.onReceiveValue(uris.takeIf { it.isNotEmpty() }?.toTypedArray())
    }

    private fun hasCameraApp(): Boolean =
        Intent(MediaStore.ACTION_IMAGE_CAPTURE).resolveActivity(activity.packageManager) != null

    private fun deleteOldCaptures() {
        val cutoff = System.currentTimeMillis() - TimeUnit.DAYS.toMillis(1)
        captureDir.listFiles()?.filter { it.lastModified() < cutoff }?.forEach(File::delete)
    }

    private val UploadSource.label
        get() = when (this) {
            UploadSource.TakePhoto -> R.string.upload_take_photo
            UploadSource.RecordVideo -> R.string.upload_record_video
            UploadSource.Gallery -> R.string.upload_gallery
            UploadSource.Files -> R.string.upload_files
        }

    private companion object {
        /** `accept=".jpg, image/png"` becomes `[image/jpeg, image/png]`. */
        fun normalise(acceptTypes: Array<String>?): List<String> = acceptTypes.orEmpty()
            .flatMap { it.split(',') }
            .map { it.trim().lowercase() }
            .filter { it.isNotEmpty() }
            .mapNotNull { type ->
                if (type.startsWith('.')) {
                    MimeTypeMap.getSingleton().getMimeTypeFromExtension(type.drop(1))
                } else {
                    type
                }
            }
            .distinct()

        fun mediaType(kind: MediaKind): PickVisualMedia.VisualMediaType = when (kind) {
            MediaKind.Images -> PickVisualMedia.ImageOnly
            MediaKind.Videos -> PickVisualMedia.VideoOnly
            else -> PickVisualMedia.ImageAndVideo
        }
    }
}
