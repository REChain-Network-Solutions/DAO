/**
 * PushNotifications
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.push

import android.app.Application
import android.content.Intent
import androidx.core.net.toUri
import com.onesignal.OneSignal
import com.onesignal.notifications.INotificationClickEvent
import com.onesignal.notifications.INotificationClickListener
import com.onesignal.user.subscriptions.IPushSubscriptionObserver
import com.onesignal.user.subscriptions.PushSubscriptionChangedState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import sngine.app.webview.MainActivity
import sngine.app.webview.SngineConfig

/** OneSignal push notifications. Does nothing when no App ID is configured. */
class PushNotifications(private val app: Application) {

    private val enabled = SngineConfig.ONESIGNAL_APP_ID.isNotBlank()
    private val _subscriptionId = MutableStateFlow<String?>(null)

    /** The OneSignal subscription ID, once the device is registered. */
    val subscriptionId: StateFlow<String?> = _subscriptionId.asStateFlow()

    fun init() {
        if (!enabled) return
        OneSignal.initWithContext(app, SngineConfig.ONESIGNAL_APP_ID)

        val subscription = OneSignal.User.pushSubscription
        _subscriptionId.value = subscription.id.ifBlank { null }
        subscription.addObserver(object : IPushSubscriptionObserver {
            override fun onPushSubscriptionChange(state: PushSubscriptionChangedState) {
                _subscriptionId.value = state.current.id.ifBlank { null }
            }
        })

        // Open the notification's URL inside the app instead of the browser.
        OneSignal.Notifications.addClickListener(object : INotificationClickListener {
            override fun onClick(event: INotificationClickEvent) {
                val url = event.notification.launchURL
                    ?: event.notification.additionalData?.optString("url")?.ifBlank { null }
                    ?: return
                app.startActivity(
                    Intent(Intent.ACTION_VIEW, url.toUri(), app, MainActivity::class.java)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
                )
            }
        })
    }

    /** Shows the Android 13+ notification permission dialog if it hasn't been answered yet. */
    suspend fun requestPermission() {
        if (enabled && SngineConfig.ASK_NOTIFICATION_PERMISSION) {
            OneSignal.Notifications.requestPermission(false)
        }
    }
}
