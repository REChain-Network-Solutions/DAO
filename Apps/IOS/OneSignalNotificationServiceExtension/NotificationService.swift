import OneSignalExtension
import UserNotifications

/// Lets OneSignal add images, buttons and badges to notifications before iOS shows them.
final class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var receivedRequest: UNNotificationRequest?
    private var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        receivedRequest = request
        self.contentHandler = contentHandler
        bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent

        if let bestAttemptContent {
            OneSignalExtension.didReceiveNotificationExtensionRequest(
                request,
                with: bestAttemptContent,
                withContentHandler: contentHandler
            )
        } else {
            contentHandler(request.content)
        }
    }

    /// iOS is about to stop the extension: deliver what we have.
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let receivedRequest, let bestAttemptContent {
            OneSignalExtension.serviceExtensionTimeWillExpireRequest(receivedRequest, with: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}
