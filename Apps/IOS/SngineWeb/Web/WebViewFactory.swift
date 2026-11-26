import UIKit
import WebKit

/// Builds the app's single WKWebView with all settings in one place.
@MainActor
enum WebViewFactory {

    /// Name of the JavaScript → native message channel (`window.webkit.messageHandlers.sngine`).
    static let messageChannel = "sngine"

    static func make(messageHandler: WKScriptMessageHandler) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        if SngineConfig.APPEND_TO_DEFAULT_USER_AGENT {
            configuration.applicationNameForUserAgent = SngineConfig.USER_AGENT
        }

        let content = configuration.userContentController
        content.add(WeakScriptMessageHandler(messageHandler), contentWorld: .page, name: messageChannel)
        for script in userScripts() {
            content.addUserScript(script)
        }

        let webView = WKWebView(frame: .zero, configuration: configuration)
        if !SngineConfig.APPEND_TO_DEFAULT_USER_AGENT {
            webView.customUserAgent = SngineConfig.USER_AGENT
        }
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = false
        // Transparent, so the controller's edge fills show above and below the page.
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        #if DEBUG
        webView.isInspectable = true // Safari → Develop menu on a Mac.
        #endif
        return webView
    }

    private static func userScripts() -> [WKUserScript] {
        var scripts = [
            // Tells the app when the first page has painted, so the splash can fade out.
            WKUserScript(
                source: """
                requestAnimationFrame(function () { requestAnimationFrame(function () {
                  window.webkit.messageHandlers.\(messageChannel).postMessage({ type: 'visible' });
                }); });
                """,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            ),
        ]
        if SngineConfig.ENABLE_LOCATION {
            scripts.append(WKUserScript(source: LocationBridge.script, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        }
        if !SngineConfig.ENABLE_ZOOM {
            scripts.append(WKUserScript(
                source: """
                (function () {
                  var meta = document.querySelector('meta[name=viewport]');
                  if (!meta) { meta = document.createElement('meta'); meta.name = 'viewport'; document.head.appendChild(meta); }
                  meta.content = 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no';
                })();
                """,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            ))
        }
        if !SngineConfig.ENABLE_TEXT_SELECTION {
            scripts.append(WKUserScript(
                source: """
                (function () {
                  var style = document.createElement('style');
                  style.textContent = 'body { -webkit-user-select: none; -webkit-touch-callout: none; } ' +
                    'input, textarea, [contenteditable] { -webkit-user-select: text; }';
                  document.head.appendChild(style);
                })();
                """,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            ))
        }
        return scripts
    }
}

/// WKUserContentController keeps its handlers alive; this proxy avoids a retain cycle with the controller.
final class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var target: WKScriptMessageHandler?

    init(_ target: WKScriptMessageHandler) {
        self.target = target
    }

    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        target?.userContentController(controller, didReceive: message)
    }
}
