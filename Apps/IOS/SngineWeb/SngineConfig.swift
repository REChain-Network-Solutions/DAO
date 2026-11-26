import Foundation

/// ┌──────────────────────────────────────────────────────────────┐
/// │  SNGINE APP CONFIGURATION                                     │
/// │  Edit the values below, then rebuild the app.                 │
/// │                                                               │
/// │  App name, colors, splash logo and icon:                      │
/// │      Assets.xcassets and the target's General tab             │
/// └──────────────────────────────────────────────────────────────┘
enum SngineConfig {

    // MARK: - Website

    /// Full URL of your Sngine website, including the trailing slash.
    static let SITE_URL = "https://demo.sngine.com/"

    /// Your OneSignal App ID. Leave empty to disable push notifications.
    static let ONESIGNAL_APP_ID = ""

    /// Custom link scheme, e.g. `sngine://demo.sngine.com/posts/1` opens that page in the app.
    /// If you change it, also change URL Types in Info.plist.
    static let DEEP_LINK_SCHEME = "sngine"

    /// Your app's numeric App Store ID (from App Store Connect), used by `rate:` links.
    /// Leave empty to show Apple's in-app rating dialog instead.
    static let APP_STORE_ID = ""

    // MARK: - Uploads

    // Photo, camera and file uploads use the built-in iOS picker, so there is nothing to set here.

    // MARK: - Features

    /// Let the website use the device location (asked only when the website needs it).
    static let ENABLE_LOCATION = true

    /// Ask for location permission right after launch instead of waiting for the website.
    static let ASK_LOCATION_ON_LAUNCH = false

    /// Ask for notification permission after the first page loads (needs ONESIGNAL_APP_ID).
    static let ASK_NOTIFICATION_PERMISSION = true

    /// Pull down at the top of a page to reload it.
    static let ENABLE_PULL_TO_REFRESH = true

    /// Pull-to-refresh is turned off on pages whose URL contains any of these.
    static let PULL_TO_REFRESH_DISABLED_ON = ["/reels"]

    /// Thin loading bar at the top while a page loads.
    static let SHOW_PROGRESS_BAR = true

    /// Pinch to zoom web pages.
    static let ENABLE_ZOOM = false

    /// Long-press to select and copy text.
    static let ENABLE_TEXT_SELECTION = true

    /// Open links to other websites in Safari instead of inside the app.
    static let OPEN_EXTERNAL_LINKS_IN_BROWSER = false

    /// Keep the app in portrait orientation on iPhone (full-screen videos can still rotate).
    static let LOCK_PORTRAIT = true

    // MARK: - User agent

    /// Sent to your website so it can detect the iOS app.
    static let USER_AGENT = "SngineIOS"

    /// `false` sends only USER_AGENT (classic Sngine behaviour).
    /// `true` adds it to the end of the normal Safari user agent, which some embeds
    /// (YouTube, maps, captcha) need to work correctly.
    static let APPEND_TO_DEFAULT_USER_AGENT = false

    // MARK: - Splash screen

    /// The splash stays until the first page appears, but never longer than this (seconds).
    static let SPLASH_MAX_DURATION: TimeInterval = 4

    // MARK: - Rate the app (App Store review dialog)

    /// Ask happy users to rate the app on the App Store.
    static let ENABLE_RATING_PROMPT = true

    /// Days after install before the first ask.
    static let RATING_MIN_DAYS = 3

    /// App launches before the first ask.
    static let RATING_MIN_LAUNCHES = 10

    /// Days to wait before asking again.
    static let RATING_REMIND_DAYS = 2
}
