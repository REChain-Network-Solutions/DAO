import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    let push = PushNotifications()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        push.start(launchOptions: launchOptions)
        return true
    }
}
