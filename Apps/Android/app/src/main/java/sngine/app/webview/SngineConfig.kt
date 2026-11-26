/**
 * SngineConfig
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview

/**
 * ┌──────────────────────────────────────────────────────────────┐
 * │  SNGINE APP CONFIGURATION                                     │
 * │  Edit the values below, then rebuild the app.                 │
 * │                                                               │
 * │  App name, colors and splash screen:                          │
 * │      res/values/sngine_config.xml                             │
 * └──────────────────────────────────────────────────────────────┘
 */
object SngineConfig {

    /* ── Website ─────────────────────────────────────────────── */

    /** Full URL of your Sngine website, including the trailing slash. */
    const val SITE_URL = "https://demo.sngine.com/"

    /** Your OneSignal App ID. Leave empty to disable push notifications. */
    const val ONESIGNAL_APP_ID = ""

    /**
     * Custom link scheme, e.g. `sngine://demo.sngine.com/posts/1` opens that page in the app.
     * If you change it, also change `android:scheme` in AndroidManifest.xml.
     */
    const val DEEP_LINK_SCHEME = "sngine"

    /* ── Uploads ─────────────────────────────────────────────── */

    /** Allow uploading files from the website (photos, videos, documents). */
    const val ENABLE_FILE_UPLOAD = true

    /** Offer "Take a photo" / "Record a video" when uploading. */
    const val ENABLE_CAMERA_UPLOAD = true

    /** Only allow camera uploads (no gallery or files). */
    const val CAMERA_ONLY = false

    /* ── Features ────────────────────────────────────────────── */

    /** Let the website use the device location (asked only when the website needs it). */
    const val ENABLE_LOCATION = true

    /** Ask for location permission right after launch instead of waiting for the website. */
    const val ASK_LOCATION_ON_LAUNCH = false

    /** Ask for notification permission after the first page loads (needs ONESIGNAL_APP_ID). */
    const val ASK_NOTIFICATION_PERMISSION = true

    /** Pull down at the top of a page to reload it. */
    const val ENABLE_PULL_TO_REFRESH = true

    /** Pull-to-refresh is turned off on pages whose URL contains any of these. */
    val PULL_TO_REFRESH_DISABLED_ON = listOf("/reels")

    /** Thin loading bar at the top while a page loads. */
    const val SHOW_PROGRESS_BAR = true

    /** Pinch to zoom web pages. */
    const val ENABLE_ZOOM = false

    /** Long-press to select and copy text. */
    const val ENABLE_TEXT_SELECTION = true

    /** Open links to other websites in the phone's browser instead of inside the app. */
    const val OPEN_EXTERNAL_LINKS_IN_BROWSER = false

    /**
     * Color the status bar and navigation bar like the top and bottom of the website.
     * `false` keeps the fixed colors from res/values/sngine_config.xml.
     */
    const val SYSTEM_BARS_FOLLOW_PAGE = true

    /** Keep the app in portrait orientation on phones. */
    const val LOCK_PORTRAIT = true

    /** Pause page timers while the app is in the background to save battery. */
    const val PAUSE_IN_BACKGROUND = true

    /* ── User agent ──────────────────────────────────────────── */

    /** Sent to your website so it can detect the Android app. */
    const val USER_AGENT = "SngineAndroid"

    /**
     * `false` sends only [USER_AGENT] (classic Sngine behaviour).
     * `true` adds it to the end of the normal Chrome user agent, which some embeds
     * (YouTube, maps, captcha) need to work correctly.
     */
    const val APPEND_TO_DEFAULT_USER_AGENT = false

    /* ── Splash screen ───────────────────────────────────────── */

    /** The splash stays until the first page appears, but never longer than this. */
    const val SPLASH_MAX_DURATION_MS = 4_000L

    /* ── Rate the app (Google Play in-app review) ────────────── */

    /** Ask happy users to rate the app on Google Play. */
    const val ENABLE_RATING_PROMPT = true

    /** Days after install before the first ask. */
    const val RATING_MIN_DAYS = 3

    /** App launches before the first ask. */
    const val RATING_MIN_LAUNCHES = 10

    /** Days to wait before asking again. */
    const val RATING_REMIND_DAYS = 2
}
