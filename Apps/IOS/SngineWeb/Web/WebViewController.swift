import StoreKit
import SwiftUI
import UIKit
import WebKit

/// The app's root screen: owns the web view and wires the pieces together
/// (the iOS counterpart of Android's MainActivity).
@MainActor
final class WebViewController: UIViewController {
    private let push: PushNotifications
    private let state = WebState()
    private let router = URLRouter(
        siteURL: SngineConfig.SITE_URL,
        deepLinkScheme: SngineConfig.DEEP_LINK_SCHEME,
        openExternalLinksInBrowser: SngineConfig.OPEN_EXTERNAL_LINKS_IN_BROWSER
    )

    private lazy var webView = WebViewFactory.make(messageHandler: self)
    private lazy var downloads = Downloads(presenter: self, sourceView: view)
    private lazy var navigation = NavigationDelegate(router: router, downloads: downloads, host: self)
    private lazy var uiDelegate = UIDelegate(router: router, host: self)
    private lazy var location = LocationBridge(router: router, host: self)
    private lazy var overlays = UIHostingController(rootView: Overlays(state: state) { [weak self] in self?.retry() })
    private let connectivity = Connectivity()
    private let reviewPrompt = ReviewPrompt()
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let refreshControl = UIRefreshControl()
    private let topFill = UIView()
    private let bottomFill = UIView()
    private var observations: [NSKeyValueObservation] = []
    private var launchURL: URL?
    private var failedURL: URL?
    private var firstPageShown = false
    private var pageIsDark: Bool?
    private var edgesTask: Task<Void, Never>?

    init(push: PushNotifications, launchURL: URL?) {
        self.push = push
        self.launchURL = launchURL
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PageBackground")
        layoutWebView()
        layoutProgressBar()
        layoutOverlays()
        setUpPullToRefresh()

        webView.navigationDelegate = navigation
        webView.uiDelegate = uiDelegate
        location.attach(to: webView)
        observeWebView()

        // Start loading right away so the network work happens behind the splash screen.
        load(launchURL.flatMap(internalURL(from:)) ?? SngineConfig.SITE_URL)
        launchURL = nil
        holdSplash()

        reviewPrompt.recordLaunch()
        connectivity.start { [weak self] online in
            if online, self?.state.failure != nil { self?.retry() }
        }
        push.onSubscriptionChange = { [weak self] _ in self?.sendPushIDToWebsite() }
        push.onOpenURL = { [weak self] url in self?.open(url) }
    }

    // MARK: - Status bar & orientation

    /// Readable status bar on top of the page: light text on dark pages, dark text on light pages.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let pageIsDark, !state.showSplash else { return .default }
        return pageIsDark ? .lightContent : .darkContent
    }

    /// Portrait on iPhone (SngineConfig.LOCK_PORTRAIT); full-screen video is presented separately and can rotate.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return .all }
        return SngineConfig.LOCK_PORTRAIT ? .portrait : .allButUpsideDown
    }

    /// Matches the edges to what the page draws there, like Safari's tinted bars (debounced).
    /// Empty space above the page (behind the status bar, or when bouncing) takes the color of the page's
    /// first row, empty space below takes its last row, and the status bar text follows what's under it.
    private func updateEdges() {
        edgesTask?.cancel()
        edgesTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard let self, !Task.isCancelled else { return }
            let scrollView = self.webView.scrollView
            let width = self.webView.bounds.width, height = self.webView.bounds.height
            let contentTop = -scrollView.contentOffset.y
            let contentBottom = scrollView.contentSize.height - scrollView.contentOffset.y
            let statusBarHeight = self.view.safeAreaInsets.top

            if let first = await EdgeColorSampler.averageColor(of: self.webView, in: CGRect(x: 0, y: max(contentTop, 0), width: width, height: 4)) {
                self.topFill.backgroundColor = first
            }
            if contentBottom < height, let last = await EdgeColorSampler.averageColor(
                of: self.webView, in: CGRect(x: 0, y: contentBottom - 4, width: width, height: 4)
            ) {
                self.bottomFill.backgroundColor = last
            }

            // Behind the status bar is either the top fill (page starts lower) or the page itself.
            let behindStatusBar = contentTop >= statusBarHeight - 1
                ? self.topFill.backgroundColor
                : await EdgeColorSampler.averageColor(of: self.webView, in: CGRect(x: 0, y: 0, width: width, height: statusBarHeight))
            if let behindStatusBar {
                let isDark = EdgeColorSampler.isDark(behindStatusBar)
                if isDark != self.pageIsDark {
                    self.pageIsDark = isDark
                    UIView.animate(withDuration: 0.2) { self.setNeedsStatusBarAppearanceUpdate() }
                }
            }
        }
    }

    // MARK: - Layout

    /// Edge to edge: WebKit keeps the page content inside the safe area and fills the area behind the
    /// status bar and home indicator with the page's own background color, so there are no bars.
    private func layoutWebView() {
        // Behind the web view: what shows above and below the page (filled with the page's edge colors).
        for fill in [topFill, bottomFill] {
            fill.backgroundColor = UIColor(named: "PageBackground")
            fill.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(fill)
        }
        NSLayoutConstraint.activate([
            topFill.topAnchor.constraint(equalTo: view.topAnchor),
            topFill.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            bottomFill.topAnchor.constraint(equalTo: view.centerYAnchor),
            bottomFill.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ] + [topFill, bottomFill].flatMap { [
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ] })

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func layoutProgressBar() {
        guard SngineConfig.SHOW_PROGRESS_BAR else { return }
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor(named: "BrandPrimary")
        progressView.trackTintColor = .clear
        progressView.alpha = 0
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.5),
        ])
    }

    private func layoutOverlays() {
        addChild(overlays)
        overlays.view.backgroundColor = .clear
        overlays.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlays.view)
        NSLayoutConstraint.activate([
            overlays.view.topAnchor.constraint(equalTo: view.topAnchor),
            overlays.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlays.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlays.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        overlays.didMove(toParent: self)
        updateOverlayTouches()
    }

    /// The overlay layer only takes touches while the splash or offline screen is showing.
    private func updateOverlayTouches() {
        overlays.view.isUserInteractionEnabled = state.isCovering
    }

    private func setFailure(_ failure: WebState.Failure?) {
        guard state.failure != failure else { return }
        withAnimation(.easeInOut(duration: 0.2)) { state.failure = failure }
        updateOverlayTouches()
    }

    private func setUpPullToRefresh() {
        refreshControl.tintColor = UIColor(named: "BrandPrimary")
        refreshControl.addAction(UIAction { [weak self] _ in self?.webView.reload() }, for: .valueChanged)
        updatePullToRefresh(for: nil)
    }

    private func updatePullToRefresh(for url: URL?) {
        let path = url?.absoluteString ?? ""
        let allowed = SngineConfig.ENABLE_PULL_TO_REFRESH
            && !SngineConfig.PULL_TO_REFRESH_DISABLED_ON.contains { path.contains($0) }
        webView.scrollView.refreshControl = allowed ? refreshControl : nil
        webView.scrollView.alwaysBounceVertical = allowed // Short pages can be pulled too.
    }

    private func observeWebView() {
        observations = [
            webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
                MainActor.assumeIsolated { self?.updateProgress(webView.estimatedProgress, loading: webView.isLoading) }
            },
            webView.observe(\.isLoading, options: [.new]) { [weak self] webView, _ in
                MainActor.assumeIsolated { self?.updateProgress(webView.estimatedProgress, loading: webView.isLoading) }
            },
            // Single-page navigation (history.pushState) changes the URL without a new page load.
            webView.observe(\.url, options: [.new]) { [weak self] webView, _ in
                MainActor.assumeIsolated {
                    self?.updatePullToRefresh(for: webView.url)
                    self?.updateEdges()
                }
            },
            // Scrolling changes what's behind the status bar.
            webView.scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, _ in
                MainActor.assumeIsolated { self?.updateEdges() }
            },
            // Changes when the website switches between light and dark theme.
            webView.observe(\.underPageBackgroundColor, options: [.new]) { [weak self] _, _ in
                MainActor.assumeIsolated { self?.updateEdges() }
            },
        ]
    }

    private func updateProgress(_ progress: Double, loading: Bool) {
        guard SngineConfig.SHOW_PROGRESS_BAR else { return }
        if loading {
            progressView.alpha = 1
            progressView.setProgress(Float(progress), animated: true)
        } else {
            UIView.animate(withDuration: 0.25, animations: { self.progressView.alpha = 0 }) { _ in
                self.progressView.setProgress(0, animated: false)
            }
        }
    }

    // MARK: - Loading

    func load(_ url: String) {
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }

    /// Deep link, website link or notification URL that opened the app.
    func open(_ url: URL) {
        guard isViewLoaded else {
            launchURL = url
            return
        }
        if let target = internalURL(from: url) {
            setFailure(nil)
            load(target)
        }
    }

    func retry() {
        setFailure(nil)
        if let failedURL {
            webView.load(URLRequest(url: failedURL))
        } else if webView.url == nil {
            load(SngineConfig.SITE_URL)
        } else {
            webView.reload()
        }
    }

    private func internalURL(from url: URL) -> String? {
        let link = url.absoluteString
        if let https = router.deepLinkToHTTPS(link) { return https }
        let scheme = URLRouter.scheme(of: link)
        return (scheme == "http" || scheme == "https") && router.isInternal(link) ? link : nil
    }

    // MARK: - Splash & first page

    private func holdSplash() {
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(SngineConfig.SPLASH_MAX_DURATION))
            self?.firstPageVisible()
        }
    }

    /// Runs once: hide the splash, then ask for permissions and schedule the rating prompt.
    private func firstPageVisible() {
        guard !firstPageShown else { return }
        firstPageShown = true
        withAnimation(.easeOut(duration: 0.35)) { state.showSplash = false }
        updateOverlayTouches()
        updateEdges()
        setNeedsStatusBarAppearanceUpdate()

        if SngineConfig.ASK_LOCATION_ON_LAUNCH { location.requestPermissionIfNeeded() }
        location.refreshCookies()
        push.requestPermission()
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(60))
            guard let self, UIApplication.shared.applicationState == .active else { return }
            self.reviewPrompt.maybeAsk(in: self.view.window?.windowScene)
        }
    }

    /// Lets Sngine link this device to the logged-in user for push notifications.
    private func sendPushIDToWebsite() {
        guard let id = push.subscriptionID, let url = webView.url?.absoluteString, router.isInternal(url) else { return }
        let quoted = (try? JSONSerialization.data(withJSONObject: [id]))
            .flatMap { String(data: $0, encoding: .utf8) }
            .map { String($0.dropFirst().dropLast()) } ?? "\"\""
        webView.evaluateJavaScript(
            "if (typeof saveIOSOneSignalUserId === 'function') saveIOSOneSignalUserId(\(quoted));"
        )
    }

    // MARK: - Special links

    private func openExternally(_ link: String) {
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url) { [weak self] opened in
            guard !opened else { return }
            let alert = UIAlertController(title: nil, message: String(localized: "No app found to open this link."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default))
            self?.present(alert)
        }
    }

    private func share(_ link: String) {
        var items: [Any] = []
        if let title = webView.title, !title.isEmpty { items.append(title) }
        items.append(URL(string: link) ?? link)
        let sheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
        sheet.popoverPresentationController?.sourceView = view
        sheet.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        present(sheet)
    }

    private func rateApp() {
        if !SngineConfig.APP_STORE_ID.isEmpty {
            openExternally("https://apps.apple.com/app/id\(SngineConfig.APP_STORE_ID)?action=write-review")
        } else if let scene = view.window?.windowScene {
            AppStore.requestReview(in: scene)
        }
    }
}

// MARK: - WebHost

extension WebViewController: WebHost {

    func perform(_ action: URLAction) -> Bool {
        switch action {
        case .allow:
            return false
        case .load(let url):
            load(url)
        case .reload(let home):
            if home { load(SngineConfig.SITE_URL) } else { webView.reload() }
        case .openExternally(let url):
            openExternally(url)
        case .share(let url):
            share(url)
        case .rateApp:
            rateApp()
        case .exit:
            break // Apple doesn't allow apps to close themselves.
        }
        return true
    }

    func pageCommitted(_ url: URL?) {
        failedURL = nil
        setFailure(nil)
        updatePullToRefresh(for: url)
    }

    func pageFinished() {
        refreshControl.endRefreshing()
        updateEdges()
        sendPushIDToWebsite()
    }

    func mainFrameFailed(_ error: Error) {
        refreshControl.endRefreshing()
        let error = error as NSError
        failedURL = error.userInfo[NSURLErrorFailingURLErrorKey] as? URL
        let offlineCodes = [
            NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost,
            NSURLErrorDataNotAllowed, NSURLErrorInternationalRoamingOff, NSURLErrorTimedOut,
        ]
        let offline = !connectivity.isOnline || (error.domain == NSURLErrorDomain && offlineCodes.contains(error.code))
        setFailure(offline ? .offline : .error)
        firstPageVisible()
    }

    func contentProcessTerminated() {
        if webView.url == nil { load(SngineConfig.SITE_URL) } else { webView.reload() }
    }

    func present(_ viewController: UIViewController) {
        var top: UIViewController = self
        while let presented = top.presentedViewController { top = presented }
        top.present(viewController, animated: true)
    }
}

// MARK: - Messages from the page

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any], let type = body["type"] as? String else { return }
        switch type {
        case "visible" where message.frameInfo.isMainFrame:
            firstPageVisible()
        case "location":
            location.handle(body, from: message.frameInfo)
        default:
            break
        }
    }
}
