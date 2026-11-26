import UIKit
import WebKit

/// Browser chrome: JavaScript dialogs, new windows and camera/microphone access.
@MainActor
final class UIDelegate: NSObject, WKUIDelegate {
    private let router: URLRouter
    private weak var host: WebHost?

    init(router: URLRouter, host: WebHost) {
        self.router = router
        self.host = host
    }

    // MARK: - window.open / target="_blank"

    /// Opens new windows in the same web view (or another app, per the link rules).
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for action: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if action.targetFrame == nil, let url = action.request.url {
            if host?.perform(router.route(url.absoluteString)) != true {
                webView.load(action.request)
            }
        }
        return nil
    }

    // MARK: - alert() / confirm() / prompt()

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        await withCheckedContinuation { continuation in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default) { _ in continuation.resume() })
            present(alert, orElse: { continuation.resume() })
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async -> Bool {
        await withCheckedContinuation { continuation in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel) { _ in continuation.resume(returning: false) })
            alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default) { _ in continuation.resume(returning: true) })
            present(alert, orElse: { continuation.resume(returning: false) })
        }
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo
    ) async -> String? {
        await withCheckedContinuation { continuation in
            let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
            alert.addTextField { $0.text = defaultText }
            alert.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel) { _ in continuation.resume(returning: nil) })
            alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default) { [weak alert] _ in
                continuation.resume(returning: alert?.textFields?.first?.text ?? "")
            })
            present(alert, orElse: { continuation.resume(returning: nil) })
        }
    }

    // MARK: - Camera / microphone (calls, live video)

    /// Only this website may use the camera and microphone; iOS still asks the user the first time.
    func webView(
        _ webView: WKWebView,
        decideMediaCapturePermissionsFor origin: WKSecurityOrigin,
        initiatedBy frame: WKFrameInfo,
        type: WKMediaCaptureType
    ) async -> WKPermissionDecision {
        router.isInternal(host: origin.host) ? .grant : .deny
    }

    private func present(_ alert: UIAlertController, orElse fallback: () -> Void) {
        if let host {
            host.present(alert)
        } else {
            fallback()
        }
    }
}
