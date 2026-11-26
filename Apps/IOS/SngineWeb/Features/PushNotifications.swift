import OneSignalFramework
import UIKit

/// OneSignal push notifications. Does nothing when no App ID is configured.
@MainActor
final class PushNotifications: NSObject {

    var isEnabled: Bool { !SngineConfig.ONESIGNAL_APP_ID.isEmpty }

    /// The OneSignal subscription ID, once the device is registered.
    private(set) var subscriptionID: String?

    /// Called when the subscription ID becomes available or changes.
    var onSubscriptionChange: ((String) -> Void)?

    /// Called with the URL of a tapped notification. A URL tapped before the screen is ready is kept until then.
    var onOpenURL: ((URL) -> Void)? {
        didSet {
            if let url = pendingURL, let onOpenURL {
                pendingURL = nil
                onOpenURL(url)
            }
        }
    }

    private var pendingURL: URL?

    func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard isEnabled else { return }
        OneSignal.initialize(SngineConfig.ONESIGNAL_APP_ID, withLaunchOptions: launchOptions)
        subscriptionID = OneSignal.User.pushSubscription.id
        OneSignal.User.pushSubscription.addObserver(self)
        OneSignal.Notifications.addClickListener(self)
    }

    /// Shows the iOS notification permission dialog if it hasn't been answered yet.
    func requestPermission() {
        guard isEnabled, SngineConfig.ASK_NOTIFICATION_PERMISSION else { return }
        OneSignal.Notifications.requestPermission({ _ in }, fallbackToSettings: false)
    }

    private func updateSubscription(_ id: String?) {
        guard let id, !id.isEmpty, id != subscriptionID else { return }
        subscriptionID = id
        onSubscriptionChange?(id)
    }

    private func open(_ url: URL) {
        if let onOpenURL {
            onOpenURL(url)
        } else {
            pendingURL = url
        }
    }
}

extension PushNotifications: OSPushSubscriptionObserver {
    nonisolated func onPushSubscriptionDidChange(state: OSPushSubscriptionChangedState) {
        let id = state.current.id
        Task { @MainActor in self.updateSubscription(id) }
    }
}

extension PushNotifications: OSNotificationClickListener {
    /// Opens the notification's URL inside the app instead of Safari.
    nonisolated func onClick(event: OSNotificationClickEvent) {
        let link = event.notification.launchURL ?? event.notification.additionalData?["url"] as? String
        guard let link, let url = URL(string: link) else { return }
        Task { @MainActor in self.open(url) }
    }
}
