import Foundation

/// What to do with a URL the website navigates to.
enum URLAction: Equatable {
    /// Let the web view load it normally.
    case allow
    /// Load a rewritten URL inside the app.
    case load(String)
    /// Reload the current page, or go back to the home page.
    case reload(home: Bool)
    /// Hand the URL to another app (Safari, Phone, Mail, WhatsApp…).
    case openExternally(String)
    /// `share:<url>` — open the share sheet.
    case share(String)
    /// `rate:` — open the App Store review page.
    case rateApp
    /// `exit:` — iOS apps can't quit themselves, so this is ignored.
    case exit
}

/// Decides how main-frame navigations are handled. Pure Swift so it can be unit tested.
///
/// Supported special links (use them as `href` on your website):
/// `refresh:` / `refresh:URL`, `share:<url>`, `rate:ios`, `exit:ios`, `<scheme>://host/path`.
struct URLRouter {
    private let siteHost: String?
    private let deepLinkScheme: String
    private let openExternalLinksInBrowser: Bool

    /// Schemes the web view handles itself.
    static let webSchemes: Set<String> = ["http", "https", "about", "data", "blob", "javascript", "file", ""]

    init(siteURL: String, deepLinkScheme: String, openExternalLinksInBrowser: Bool) {
        self.siteHost = Self.host(of: siteURL)
        self.deepLinkScheme = deepLinkScheme.lowercased()
        self.openExternalLinksInBrowser = openExternalLinksInBrowser
    }

    /// `userTapped` is true for links the user tapped; redirects (e.g. social logins) always stay in the app.
    func route(_ url: String, userTapped: Bool = true) -> URLAction {
        switch Self.scheme(of: url) {
        case deepLinkScheme:
            return deepLinkToHTTPS(url).map(URLAction.load) ?? .openExternally(url)
        case "refresh":
            return .reload(home: Self.payload(of: url).caseInsensitiveCompare("URL") == .orderedSame)
        case "share":
            return .share(Self.payload(of: url))
        case "rate":
            return .rateApp
        case "exit":
            return .exit
        case "http", "https":
            return openExternalLinksInBrowser && userTapped && !isInternal(url) ? .openExternally(url) : .allow
        case let scheme where Self.webSchemes.contains(scheme):
            return .allow
        default:
            return .openExternally(url)
        }
    }

    /// `sngine://example.com/path` → `https://example.com/path`, only for this website's host.
    func deepLinkToHTTPS(_ url: String) -> String? {
        guard Self.scheme(of: url) == deepLinkScheme, let range = url.range(of: "://") else { return nil }
        let https = "https://" + url[range.upperBound...]
        return isInternal(https) ? https : nil
    }

    /// True when the URL points at this website or one of its subdomains.
    func isInternal(_ url: String) -> Bool {
        guard let host = Self.host(of: url), let site = siteHost else { return false }
        return host == site || host.hasSuffix("." + site)
    }

    /// True when `host` is this website or one of its subdomains.
    func isInternal(host: String) -> Bool {
        isInternal("https://\(host)/")
    }

    static func scheme(of url: String) -> String {
        guard let colon = url.firstIndex(of: ":") else { return "" }
        return url[..<colon].trimmingCharacters(in: .whitespaces).lowercased()
    }

    static func host(of url: String) -> String? {
        guard let host = URL(string: url.trimmingCharacters(in: .whitespaces))?.host()?.lowercased() else {
            return nil
        }
        return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
    }

    private static func payload(of url: String) -> String {
        guard let colon = url.firstIndex(of: ":") else { return "" }
        return String(url[url.index(after: colon)...])
    }
}
