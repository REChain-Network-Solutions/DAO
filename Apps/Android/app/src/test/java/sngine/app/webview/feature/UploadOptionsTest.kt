/**
 * UploadOptionsTest
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class UploadOptionsTest {

    @Test
    fun `media kind from accept types`() {
        assertEquals(MediaKind.Any, MediaKind.of(emptyList()))
        assertEquals(MediaKind.Any, MediaKind.of(listOf("*/*")))
        assertEquals(MediaKind.Images, MediaKind.of(listOf("image/*", "image/png")))
        assertEquals(MediaKind.Videos, MediaKind.of(listOf("video/mp4")))
        assertEquals(MediaKind.ImagesAndVideos, MediaKind.of(listOf("image/*", "video/*")))
        assertEquals(MediaKind.Any, MediaKind.of(listOf("image/*", "application/pdf")))
    }

    @Test
    fun `photo input offers camera and gallery`() {
        assertEquals(
            listOf(UploadSource.TakePhoto, UploadSource.Gallery),
            sources(MediaKind.Images),
        )
    }

    @Test
    fun `any file input offers everything`() {
        assertEquals(
            listOf(UploadSource.TakePhoto, UploadSource.RecordVideo, UploadSource.Gallery, UploadSource.Files),
            sources(MediaKind.Any),
        )
    }

    @Test
    fun `no camera app means pickers only`() {
        assertEquals(listOf(UploadSource.Gallery), sources(MediaKind.Images, cameraAvailable = false))
        assertEquals(listOf(UploadSource.Gallery), sources(MediaKind.Images, cameraOnly = true, cameraAvailable = false))
    }

    @Test
    fun `capture attribute and camera-only skip the gallery`() {
        assertEquals(listOf(UploadSource.TakePhoto), sources(MediaKind.Images, captureRequested = true))
        assertEquals(listOf(UploadSource.RecordVideo), sources(MediaKind.Videos, cameraOnly = true))
    }

    @Test
    fun `empty camera files are never uploaded`() {
        assertTrue(UploadOptions.isCaptureUsable(success = true, fileLength = 2_048))
        assertFalse(UploadOptions.isCaptureUsable(success = true, fileLength = 0))
        assertFalse(UploadOptions.isCaptureUsable(success = false, fileLength = 2_048))
    }

    private fun sources(
        kind: MediaKind,
        cameraAvailable: Boolean = true,
        cameraOnly: Boolean = false,
        captureRequested: Boolean = false,
    ) = UploadOptions.sources(kind, cameraEnabled = true, cameraAvailable, cameraOnly, captureRequested)
}
