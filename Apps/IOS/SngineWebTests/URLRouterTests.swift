import Testing
@testable import SngineWeb

struct URLRouterTests {
    private let router = URLRouter(siteURL: "https://demo.sngine.com/", deepLinkScheme: "sngine", openExternalLinksInBrowser: false)
    private let externalRouter = URLRouter(siteURL: "https://demo.sngine.com/", deepLinkScheme: "sngine", openExternalLinksInBrowser: true)

    @Test func siteLinksLoadInTheApp() {
        #expect(router.route("https://demo.sngine.com/posts/1") == .allow)
        #expect(externalRouter.route("https://www.demo.sngine.com/reels") == .allow)
        #expect(externalRouter.route("https://cdn.demo.sngine.com/a.jpg") == .allow)
    }

    @Test func externalLinksFollowTheConfig() {
        #expect(router.route("https://youtube.com/watch?v=1") == .allow)
        #expect(externalRouter.route("https://youtube.com/watch?v=1") == .openExternally("https://youtube.com/watch?v=1"))
        // A look-alike host is not the site.
        #expect(externalRouter.route("https://evildemo.sngine.com.attacker.io/") == .openExternally("https://evildemo.sngine.com.attacker.io/"))
    }

    @Test func redirectsStayInTheAppForSocialLogins() {
        #expect(externalRouter.route("https://www.facebook.com/dialog/oauth", userTapped: false) == .allow)
    }

    @Test func appSchemesOpenOtherApps() {
        #expect(router.route("tel:+123456") == .openExternally("tel:+123456"))
        #expect(router.route("mailto:a@b.com") == .openExternally("mailto:a@b.com"))
        #expect(router.route("whatsapp://send?text=hi") == .openExternally("whatsapp://send?text=hi"))
    }

    @Test func sngineSpecialLinks() {
        #expect(router.route("refresh:ios") == .reload(home: false))
        #expect(router.route("refresh:URL") == .reload(home: true))
        #expect(router.route("share:https://demo.sngine.com/x") == .share("https://demo.sngine.com/x"))
        #expect(router.route("rate:ios") == .rateApp)
        #expect(router.route("exit:ios") == .exit)
    }

    @Test func deepLinksOnlyOpenThisWebsite() {
        #expect(router.route("sngine://demo.sngine.com/posts/1") == .load("https://demo.sngine.com/posts/1"))
        #expect(router.deepLinkToHTTPS("sngine://demo.sngine.com/") == "https://demo.sngine.com/")
        #expect(router.deepLinkToHTTPS("sngine://attacker.io/phish") == nil)
        #expect(router.deepLinkToHTTPS("https://demo.sngine.com/") == nil)
    }

    @Test func webInternalSchemesAreLeftToTheWebView() {
        #expect(router.route("about:blank") == .allow)
        #expect(router.route("data:text/html,hi") == .allow)
        #expect(router.route("blob:https://demo.sngine.com/uuid") == .allow)
    }

    @Test func isInternalHandlesBadInput() {
        #expect(router.isInternal("https://demo.sngine.com"))
        #expect(router.isInternal(host: "demo.sngine.com"))
        #expect(!router.isInternal("not a url"))
        #expect(!router.isInternal(""))
    }
}
