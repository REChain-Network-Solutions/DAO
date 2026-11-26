/**
 * Permissions
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import android.view.View
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts.RequestMultiplePermissions
import androidx.core.content.ContextCompat
import androidx.core.net.toUri
import com.google.android.material.snackbar.Snackbar
import kotlinx.coroutines.CompletableDeferred
import sngine.app.webview.R

/**
 * Asks for runtime permissions only when a feature needs them.
 * Must be created before the activity is started (e.g. as a property).
 */
class Permissions(private val activity: ComponentActivity, private val snackbarAnchor: () -> View) {

    private var pending: CompletableDeferred<Unit>? = null

    private val launcher = activity.registerForActivityResult(RequestMultiplePermissions()) {
        pending?.complete(Unit)
        pending = null
    }

    fun isGranted(permission: String): Boolean =
        ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED

    /** Requests the missing permissions and returns the ones that are granted afterwards. */
    suspend fun request(vararg permissions: String): Set<String> {
        val missing = permissions.filterNot(::isGranted)
        if (missing.isNotEmpty() && pending == null) {
            val result = CompletableDeferred<Unit>().also { pending = it }
            launcher.launch(missing.toTypedArray())
            result.await()
            if (missing.none(::isGranted) && missing.none(activity::shouldShowRequestPermissionRationale)) {
                showSettingsHint()
            }
        }
        return permissions.filter(::isGranted).toSet()
    }

    /** The user chose "Don't ask again": point them to the app settings. */
    private fun showSettingsHint() {
        Snackbar.make(snackbarAnchor(), R.string.permission_denied, Snackbar.LENGTH_LONG)
            .setAction(R.string.open_settings) {
                activity.startActivity(
                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, "package:${activity.packageName}".toUri()),
                )
            }
            .show()
    }
}
