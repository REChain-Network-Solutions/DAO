# Sngine Android App

A fast, modern Android app for your Sngine website, written in Kotlin.
It targets Android 16 (API 36), compiles against API 37, and runs on Android 8.1 and newer.

## Configure your app

You only need to edit these files:

| What                                           | File                                                       |
| ---------------------------------------------- | ---------------------------------------------------------- |
| Website URL, OneSignal ID, features            | `app/src/main/java/sngine/app/webview/SngineConfig.kt`     |
| App name, brand colors, splash colors          | `app/src/main/res/values/sngine_config.xml`                |
| Dark-mode splash colors                        | `app/src/main/res/values-night/sngine_config.xml`          |
| Splash logo                                    | `app/src/main/res/drawable-nodpi/splash_logo_image.png`    |
| Launcher icon                                  | Android Studio → right-click `res` → **New → Image Asset** |
| Package name (for your own Play Store listing) | `applicationId` in `app/build.gradle.kts`                  |
| Version                                        | `versionCode` / `versionName` in `app/build.gradle.kts`    |

### 1. Website and push notifications

Open `SngineConfig.kt`:

```kotlin
const val SITE_URL = "https://your-site.com/"
const val ONESIGNAL_APP_ID = "your-onesignal-app-id"
```

Every option in that file has a comment that explains it.

### 2. Splash screen

The app uses Android's built-in splash screen. It stays visible until your website has
loaded, but never longer than `SPLASH_MAX_DURATION_MS` (4 seconds by default).

- **Logo:** replace `res/drawable-nodpi/splash_logo_image.png` with your own square PNG
  (512×512 px or larger). Android crops the splash icon to a circle, so keep important
  parts of the logo near the centre. To make the logo bigger or smaller, change
  `android:inset` in `res/drawable/splash_logo.xml` (lower = bigger).
- **Background color:** `splash_background` in `sngine_config.xml`, plus the same entry in
  `values-night/sngine_config.xml` for dark mode.

### 3. Colors

In `sngine_config.xml`:

- `brand_primary`: progress bar, pull-to-refresh spinner and buttons.
- `system_bar_background` and `light_system_bars`: the area behind the status bar and the navigation bar
  while the app starts. After the website loads, both bars take the page's own top and bottom colors
  (set `SYSTEM_BARS_FOLLOW_PAGE = false` in `SngineConfig.kt` to keep these fixed colors).
- `page_background`: what users see behind your website while it loads.

### 4. Deep links

Links like `sngine://your-site.com/posts/123` open that page in the app. To use a different
scheme, change `DEEP_LINK_SCHEME` in `SngineConfig.kt` **and** `android:scheme` in
`AndroidManifest.xml`. Deep links only open pages on your own website.

## Special links for your website

Use these as `href` values in your Sngine theme:

| Link                                                | Action                       |
| --------------------------------------------------- | ---------------------------- |
| `refresh:android`                                   | Reload the current page      |
| `refresh:URL`                                       | Go back to the home page     |
| `share:https://…`                                   | Open the Android share sheet |
| `rate:android`                                      | Open the app on Google Play  |
| `exit:android`                                      | Leave the app                |
| `tel:`, `mailto:`, `sms:`, `whatsapp:`, `intent://` | Open the matching app        |

## Build

Open the `android` folder in Android Studio and press **Run**. To build from the command line:

```bash
./gradlew :app:assembleDebug           # debug APK
./gradlew :app:bundleRelease           # release bundle for Google Play (sign it in Android Studio)
./gradlew :app:testDebugUnitTest       # unit tests
```

### Faster startup: Baseline Profile (optional)

With an emulator or phone connected, run:

```bash
./gradlew :app:generateBaselineProfile
```

This records the app's startup path, so Google Play pre-compiles it on users' devices.
Run it again after big changes.

## Code layout

```
app/src/main/java/sngine/app/webview/
  SngineConfig.kt         your settings
  SngineApp.kt            app start-up (push notifications)
  MainActivity.kt         the single screen; wires everything together
  web/                    WebView setup, page events, link handling
  feature/                uploads, location, permissions, downloads, connectivity, rating
  push/                   OneSignal
  ui/                     offline screen, full-screen video
```

## Changes from the previous (Java) app

- **Location turned off no longer closes the app.** The app now asks to turn location on,
  and only when your website needs it.
- **Gallery uploads no longer arrive as empty 0 B files.** Picking photos uses the Android
  Photo Picker, which needs no storage permission.
- Camera, microphone and location permissions are asked only when they are needed, not all
  at launch.
- The splash screen is the system splash. It stays until the website is visible, so there is
  no fixed 1-second wait and no second splash activity.
- A native offline screen with a **Try again** button replaces `error.html`. The page reloads
  by itself when the connection comes back.
- Pages are no longer reloaded with a random `rid=` parameter, so the browser cache works and
  pages load faster.
- Rotating or folding the device no longer reloads the website.
- If the WebView's renderer crashes, the app rebuilds it instead of closing.
- For security, the old options to ignore SSL certificate errors and to allow mixed or
  universal file access were removed. Google Play rejects apps that ignore SSL errors.
- Text can be selected and copied. Set `ENABLE_TEXT_SELECTION = false` for the old behaviour.
