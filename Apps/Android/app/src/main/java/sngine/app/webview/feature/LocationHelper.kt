/**
 * LocationHelper
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.location.Location
import android.location.LocationManager
import android.webkit.CookieManager
import androidx.activity.ComponentActivity
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts.StartIntentSenderForResult
import androidx.core.content.getSystemService
import androidx.core.location.LocationManagerCompat
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withTimeoutOrNull
import sngine.app.webview.SngineConfig

/**
 * Location for the website, on demand only.
 *
 * Never crashes or posts notifications when location is off (the old app crashed there):
 * it asks once per session to turn location on and otherwise reports "not available".
 * Must be created before the activity is started (e.g. as a property).
 */
class LocationHelper(private val activity: ComponentActivity, private val permissions: Permissions) {

    private val fused by lazy { LocationServices.getFusedLocationProviderClient(activity) }
    private var askedToEnable = false
    private var pendingResolution: CompletableDeferred<Boolean>? = null

    private val resolution = activity.registerForActivityResult(StartIntentSenderForResult()) {
        pendingResolution?.complete(it.resultCode == Activity.RESULT_OK)
        pendingResolution = null
    }

    val hasPermission: Boolean
        get() = permissions.isGranted(Manifest.permission.ACCESS_FINE_LOCATION) ||
            permissions.isGranted(Manifest.permission.ACCESS_COARSE_LOCATION)

    /** Asks for permission and for location to be switched on. Returns true when location can be used. */
    suspend fun ensureReady(): Boolean {
        if (!SngineConfig.ENABLE_LOCATION) return false
        permissions.request(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
        if (!hasPermission) return false
        if (isLocationOn()) return true
        if (askedToEnable) return false
        askedToEnable = true
        return requestLocationOn()
    }

    /** Stores the last position in the `lat` / `long` cookies Sngine reads. Never prompts the user. */
    suspend fun updateCookies() {
        if (!SngineConfig.ENABLE_LOCATION || !hasPermission || !isLocationOn()) return
        val location = currentLocation() ?: return
        CookieManager.getInstance().apply {
            setCookie(SngineConfig.SITE_URL, "lat=${location.latitude}")
            setCookie(SngineConfig.SITE_URL, "long=${location.longitude}")
        }
    }

    private fun isLocationOn(): Boolean =
        activity.getSystemService<LocationManager>()?.let(LocationManagerCompat::isLocationEnabled) == true

    /** Shows the Google Play services "Turn on location" dialog. */
    private suspend fun requestLocationOn(): Boolean {
        val request = LocationSettingsRequest.Builder()
            .addLocationRequest(LocationRequest.Builder(Priority.PRIORITY_BALANCED_POWER_ACCURACY, 10_000).build())
            .build()
        return try {
            LocationServices.getSettingsClient(activity).checkLocationSettings(request).await()
            true
        } catch (e: ResolvableApiException) {
            val result = CompletableDeferred<Boolean>().also { pendingResolution = it }
            resolution.launch(IntentSenderRequest.Builder(e.resolution).build())
            result.await()
        } catch (e: CancellationException) {
            throw e
        } catch (_: Exception) {
            false // No Google Play services or settings can't be changed.
        }
    }

    @SuppressLint("MissingPermission") // Checked by hasPermission.
    private suspend fun currentLocation(): Location? {
        val token = CancellationTokenSource()
        return try {
            withTimeoutOrNull(10_000) {
                fused.getCurrentLocation(Priority.PRIORITY_BALANCED_POWER_ACCURACY, token.token).await()
            } ?: fused.lastLocation.await()
        } catch (e: CancellationException) {
            throw e
        } catch (_: Exception) {
            null
        } finally {
            token.cancel() // Stops the location request if we timed out.
        }
    }
}
