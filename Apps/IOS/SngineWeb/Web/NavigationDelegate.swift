import WebKit

/// What the web delegates need from the screen that owns the web view.
@MainActor
protocol WebHost: AnyObject {
    func perform(_ action: URLAction) -> Bool
    func pageCommitted(_ url: URL?)
    func pageFinished()
    func mainFrameFailed(_ error: Error)
    func contentProcessTerminated()
    func present(_ viewController: UIViewController)
}

/// Page lifecycle, link routing, downloads and error handling.
/// Invalid SSL certificates are always rejected (WebKit's default).
@MainActor
final class NavigationDelegate: NSObject, WKNavigationDelegate {
    private let router: URLRouter
    private let downloads: Downloads
    private weak var host: WebHost?

    init(router: URLRouter, downloads: Downloads, host: WebHost) {
        self.router = router
        self.downloads = downloads
        self.host = host
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction) async -> WKNavigationActionPolicy {
        if action.shouldPerformDownload { return .download }
        guard let url = action.request.url?.absoluteString else { return .cancel }

        // Sub-frames (embeds, ads) may only navigate to web content.
        if let frame = action.targetFrame, !frame.isMainFrame {
            return URLRouter.webSchemes.contains(URLRouter.scheme(of: url)) ? .allow : .cancel
        }
        let route = router.route(url, userTapped: action.navigationType == .linkActivated)
        return host?.perform(route) == true ? .cancel : .allow
    }

    func webView(_ webView: WKWebView, decidePolicyFor response: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard response.isForMainFrame else { return .allow }
        let disposition = (response.response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Content-Disposition")
        let isAttachment = disposition?.lowercased().hasPrefix("attachment") == true
        return isAttachment || !response.canShowMIMEType ? .download : .allow
    }

    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = downloads
    }

    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = downloads
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        host?.pageCommitted(webView.url)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        host?.pageFinished()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        report(error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        report(error)
    }

    /// The page's web process crashed (usually low memory): reload instead of showing a blank page.
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        host?.contentProcessTerminated()
    }

    private func report(_ error: Error) {
        let error = error as NSError
        // Cancelled loads and navigations turned into downloads or external links are not failures.
        let ignored = (error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled)
            || (error.domain == WKError.errorDomain && error.code == 102) // Frame load interrupted by policy change.
        if !ignored {
            host?.mainFrameFailed(error)
        }
    }
}
