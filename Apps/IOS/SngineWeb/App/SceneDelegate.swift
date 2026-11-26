import UIKit

/// Creates the window with the web view controller as its root, and forwards deep links to it.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var controller: WebViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let controller = WebViewController(push: appDelegate.push, launchURL: options.urlContexts.first?.url)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        self.window = window
        self.controller = controller
    }

    /// `sngine://…` links opened while the app is running.
    func scene(_ scene: UIScene, openURLContexts contexts: Set<UIOpenURLContext>) {
        if let url = contexts.first?.url {
            controller?.open(url)
        }
    }
}
