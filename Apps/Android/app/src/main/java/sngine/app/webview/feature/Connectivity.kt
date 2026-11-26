/**
 * Connectivity
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import androidx.core.content.getSystemService
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.distinctUntilChanged

/** Reports whether the device has a working internet connection. */
class Connectivity(context: Context) {

    private val manager = context.getSystemService<ConnectivityManager>()!!

    val isOnline: Boolean
        get() = manager.getNetworkCapabilities(manager.activeNetwork)?.isOnline() == true

    /** Emits the current state, then every change. */
    fun changes(): Flow<Boolean> = callbackFlow {
        val callback = object : ConnectivityManager.NetworkCallback() {
            override fun onCapabilitiesChanged(network: Network, caps: NetworkCapabilities) {
                trySend(caps.isOnline())
            }

            override fun onLost(network: Network) {
                trySend(isOnline)
            }
        }
        trySend(isOnline)
        manager.registerDefaultNetworkCallback(callback)
        awaitClose { manager.unregisterNetworkCallback(callback) }
    }.distinctUntilChanged()

    private fun NetworkCapabilities.isOnline() =
        hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
            hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
}
