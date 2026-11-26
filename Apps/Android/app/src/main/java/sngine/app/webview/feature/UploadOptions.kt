/**
 * UploadOptions
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

/** One entry of the upload menu. */
enum class UploadSource { TakePhoto, RecordVideo, Gallery, Files }

/** What kind of files an `<input type="file">` accepts. */
enum class MediaKind {
    Images, Videos, ImagesAndVideos, Any;

    val allowsImages get() = this != Videos
    val allowsVideos get() = this != Images

    companion object {
        /** [mimeTypes] are already normalised (lower-case, no blanks, extensions mapped to MIME types). */
        fun of(mimeTypes: List<String>): MediaKind {
            if (mimeTypes.isEmpty() || mimeTypes.any { it == "*/*" }) return Any
            val images = mimeTypes.all { it.startsWith("image/") }
            val videos = mimeTypes.all { it.startsWith("video/") }
            val media = mimeTypes.all { it.startsWith("image/") || it.startsWith("video/") }
            return when {
                images -> Images
                videos -> Videos
                media -> ImagesAndVideos
                else -> Any
            }
        }
    }
}

/** Builds the upload menu for a file input. Pure Kotlin so it can be unit tested. */
object UploadOptions {

    fun sources(
        kind: MediaKind,
        cameraEnabled: Boolean,
        cameraAvailable: Boolean,
        cameraOnly: Boolean,
        captureRequested: Boolean,
    ): List<UploadSource> {
        val camera = buildList {
            if (cameraEnabled && cameraAvailable) {
                if (kind.allowsImages) add(UploadSource.TakePhoto)
                if (kind.allowsVideos) add(UploadSource.RecordVideo)
            }
        }
        // `<input capture>` or camera-only mode: skip the gallery when the camera can serve the request.
        if ((cameraOnly || captureRequested) && camera.isNotEmpty()) return camera

        val pickers = when (kind) {
            MediaKind.Any -> listOf(UploadSource.Gallery, UploadSource.Files)
            else -> listOf(UploadSource.Gallery)
        }
        return camera + pickers
    }

    /** A capture is only uploaded if the camera app reported success and actually wrote data. */
    fun isCaptureUsable(success: Boolean, fileLength: Long): Boolean = success && fileLength > 0
}
