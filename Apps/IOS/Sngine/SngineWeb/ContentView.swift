import SwiftUI
import WebKit
import OneSignalFramework

struct ContentView: View {
    let urlString: String = "https://demo.Delus.com/" // Your main website URL

    var body: some View {
        WebView(url: URL(string: urlString)!)
    }
}

struct WebView: UIViewRepresentable {
    var url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.configuration.allowsInlineMediaPlayback = true

        // Set a custom User-Agent for WebView
        webView.customUserAgent = "Delus"

        // Add refresh control to the WKWebView's scroll view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(_:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var isSocialLoginInitiated = false

        init(_ parent: WebView) {
            self.parent = parent
        }

        @objc func handleRefreshControl(_ refreshControl: UIRefreshControl) {
            refreshControl.beginRefreshing()
            parent.url = URL(string: parent.url.absoluteString)!
            let request = URLRequest(url: parent.url)
            if let webView = refreshControl.superview?.superview as? WKWebView {
                webView.load(request)
                refreshControl.endRefreshing()
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url,
               navigationAction.navigationType == .linkActivated {
                print("Navigation URL: \(url)")
                print("Navigation Type: \(navigationAction.navigationType)")

                // Check for Social Login: only process URLs that are specifically part of the login flow
                // You can modify this check to match the URL paths related to social login for your site
                if url.absoluteString.contains("/connect/") {
                    print("Social login initiated. Loading in WebView.")
                    isSocialLoginInitiated = true
                    decisionHandler(.allow)
                } else if isSocialLoginInitiated {
                    // If social login has been initiated, allow navigation and process as part of the flow
                    print("Continuing social login flow in WebView.")
                    decisionHandler(.allow)
                    // Reset the flag if any internal page is loaded again
                    if url.host == parent.url.host {
                        print("Returned to the website. Resetting social login flag.")
                        isSocialLoginInitiated = false
                    }
                } else if url.host == parent.url.host {
                    // Allow internal links to load in WebView
                    print("Loading internal link in WebView.")
                    decisionHandler(.allow)
                } else {
                    // For all other external links, open them in Safari
                    print("Opening external link in Safari: \(url)")
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                }
            } else {
                decisionHandler(.allow)
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Ensure DOM is ready before injecting JavaScript
            webView.evaluateJavaScript("document.readyState", completionHandler: { (result, error) in
                guard let readyState = result as? String, readyState == "complete" else {
                    print("Error checking document readiness: \(error?.localizedDescription ?? "")")
                    return
                }

                // Handle OneSignal user ID
                if let oneSignalUserId = AppDelegate.oneSignalUserId, !oneSignalUserId.isEmpty {
                    let js = "saveIOSOneSignalUserId('\(oneSignalUserId)')"
                    webView.evaluateJavaScript(js) { (result, error) in
                        if let error = error {
                            print("Error injecting JavaScript: \(error.localizedDescription)")
                        } else {
                            print("JavaScript injected successfully")
                        }
                    }
                } else {
                    print("OneSignal user ID is nil or empty")
                }
            })
        }
    }
}
