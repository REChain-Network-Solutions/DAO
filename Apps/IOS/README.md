# Sngine iOS App

A fast, modern iOS app for your Sngine website, written in Swift.
It runs on iOS 17 and newer (iPhone and iPad) and needs Xcode 16 or newer to build.

## Configure your app

You only need to edit these files:

| What | Where |
| --- | --- |
| Website URL, OneSignal ID, features | `SngineWeb/SngineConfig.swift` |
| Splash logo | `SngineWeb/Assets.xcassets` → **SplashLogo** |
| Splash, page and brand colors (light + dark) | `SngineWeb/Assets.xcassets` → **SplashBackground**, **PageBackground**, **BrandPrimary** |
| App icon | `SngineWeb/Assets.xcassets` → **AppIcon** (one 1024×1024 PNG) |
| App name, bundle ID, version, signing team | Xcode → **SngineWeb** target → **General** and **Signing & Capabilities** |

### 1. Website and push notifications

Open `SngineConfig.swift`:

```swift
static let SITE_URL = "https://your-site.com/"
static let ONESIGNAL_APP_ID = "your-onesignal-app-id"
```

Every option in that file has a comment that explains it.

### 2. Splash screen

The app shows the iOS launch screen, then keeps the same picture on screen until your
website has loaded (never longer than `SPLASH_MAX_DURATION`, 4 seconds by default).

* **Logo:** in `Assets.xcassets`, drop your logo onto **SplashLogo**. A square PNG of
  about 512×512 px placed in the **3x** slot shows at roughly 170 points wide.
* **Background:** change **SplashBackground**. It has separate light and dark mode colors.

### 3. Bundle ID and signing

1. Select the **SngineWeb** target and change the **Bundle Identifier** (e.g. `com.yoursite.app`).
2. Select the **OneSignalNotificationServiceExtension** target and set its bundle ID to the same
   value followed by `.OneSignalNotificationServiceExtension`.
3. In **Signing & Capabilities**, pick your team for both targets, and change the App Group on both
   targets to `group.<your bundle id>.onesignal`.

### 4. Deep links

Links like `sngine://your-site.com/posts/123` open that page in the app. To use a different
scheme, change `DEEP_LINK_SCHEME` in `SngineConfig.swift` **and** the URL scheme in `Info.plist`.
Deep links only open pages on your own website.

## Special links for your website

Use these as `href` values in your Sngine theme:

| Link | Action |
| --- | --- |
| `refresh:ios` | Reload the current page |
| `refresh:URL` | Go back to the home page |
| `share:https://…` | Open the iOS share sheet |
| `rate:ios` | Open the App Store review page (set `APP_STORE_ID`) |
| `tel:`, `mailto:`, `sms:`, `whatsapp:` | Open the matching app |

## Build

Open `SngineWeb.xcodeproj` in Xcode, pick a simulator or your iPhone and press **Run**.
To publish, choose **Product → Archive**, then **Distribute App** → **App Store Connect**.

The project uses Xcode's folder-based groups: any file you add inside the `SngineWeb` folder is
part of the app automatically.

## Code layout

```
SngineWeb/
  SngineConfig.swift      your settings
  App/                    app start-up, push notifications, window
  Web/                    web view setup, page events, link handling, JavaScript dialogs
  Features/               location, downloads, connectivity, rating, push
  UI/                     splash and offline screens
SngineWebTests/           unit tests (Product → Test)
```

## Changes from the previous app

* **No more bars at the top and bottom.** The website now fills the whole screen, edge to edge,
  and the status bar switches between light and dark text to stay readable.
* A splash screen that stays until the website is visible, and a native offline screen with
  **Try again** that reloads by itself when the connection comes back.
* `alert()`, `confirm()` and `prompt()` from the website now work (they were silently ignored).
* One location permission prompt instead of two, and a clear message when location is off.
* Downloads work and open the share sheet (Save to Files, Save Image…).
* The notification permission is asked after the first page loads, not at launch, and the
  "Open Settings" alert no longer appears on every launch.
* Links to other websites follow `OPEN_EXTERNAL_LINKS_IN_BROWSER`, while login flows
  (Facebook, X…) always stay in the app.
