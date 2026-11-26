import CoreLocation
import UIKit
import WebKit

/// Location for the website, backed by Core Location.
///
/// The injected `script` replaces `navigator.geolocation` on this website's pages, so users see one
/// iOS permission prompt instead of the iOS prompt plus WebKit's per-site prompt. When location is
/// off or denied, the page gets a normal geolocation error and the user a one-time Settings hint.
@MainActor
final class LocationBridge: NSObject {

    static let script = """
    (function () {
      var handler = window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.\(WebViewFactory.messageChannel);
      if (!handler) return;
      var callbacks = {}, nextId = 1;
      function send(action, id, options) {
        handler.postMessage({ type: 'location', action: action, id: id,
          highAccuracy: !!(options && options.enableHighAccuracy),
          timeout: options && isFinite(options.timeout) ? options.timeout : 0 });
      }
      function error(code, message) {
        return { code: code, message: message, PERMISSION_DENIED: 1, POSITION_UNAVAILABLE: 2, TIMEOUT: 3 };
      }
      window.__sngineLocation = {
        success: function (id, coords, timestamp, keep) {
          var cb = callbacks[id]; if (!cb) return; if (!keep) delete callbacks[id];
          if (cb.success) cb.success({ coords: coords, timestamp: timestamp });
        },
        failure: function (id, code, message, keep) {
          var cb = callbacks[id]; if (!cb) return; if (!keep) delete callbacks[id];
          if (cb.error) cb.error(error(code, message));
        }
      };
      var geolocation = {
        getCurrentPosition: function (success, failure, options) {
          var id = nextId++; callbacks[id] = { success: success, error: failure }; send('get', id, options);
        },
        watchPosition: function (success, failure, options) {
          var id = nextId++; callbacks[id] = { success: success, error: failure }; send('watch', id, options); return id;
        },
        clearWatch: function (id) { delete callbacks[id]; send('clear', id); }
      };
      try { Object.defineProperty(navigator, 'geolocation', { value: geolocation, configurable: true }); } catch (e) {}
    })();
    """

    private let manager = CLLocationManager()
    private let router: URLRouter
    private weak var webView: WKWebView?
    private weak var host: WebHost?
    private var pending: Set<Int> = []
    private var watches: Set<Int> = []
    private var shownSettingsHint = false

    init(router: URLRouter, host: WebHost) {
        self.router = router
        self.host = host
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func attach(to webView: WKWebView) {
        self.webView = webView
    }

    /// Called for `{ type: 'location' }` messages from the page.
    func handle(_ body: [String: Any], from frame: WKFrameInfo) {
        guard let id = body["id"] as? Int, let action = body["action"] as? String else { return }
        guard SngineConfig.ENABLE_LOCATION, router.isInternal(host: frame.securityOrigin.host) else {
            fail(id, code: 1, message: "Location is not available", keep: false)
            return
        }
        switch action {
        case "clear":
            watches.remove(id)
            stopIfIdle()
        case "get", "watch":
            if action == "get" { pending.insert(id) } else { watches.insert(id) }
            if body["highAccuracy"] as? Bool == true { manager.desiredAccuracy = kCLLocationAccuracyBest }
            if let timeout = body["timeout"] as? Double, timeout > 0, action == "get" {
                scheduleTimeout(for: id, after: timeout / 1000)
            }
            start()
        default:
            break
        }
    }

    /// Asks for permission without waiting for the website (SngineConfig.ASK_LOCATION_ON_LAUNCH).
    func requestPermissionIfNeeded() {
        if SngineConfig.ENABLE_LOCATION, manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }

    /// Stores the current position in the `lat` / `long` cookies Sngine reads. Never prompts.
    func refreshCookies() {
        guard SngineConfig.ENABLE_LOCATION, isAuthorized else { return }
        manager.requestLocation()
    }

    private var isAuthorized: Bool {
        [.authorizedWhenInUse, .authorizedAlways].contains(manager.authorizationStatus)
    }

    private func start() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // Continues in locationManagerDidChangeAuthorization.
        case .denied, .restricted:
            failAll(code: 1, message: "User denied Geolocation")
            showSettingsHint()
        default:
            manager.startUpdatingLocation()
        }
    }

    private func stopIfIdle() {
        if pending.isEmpty && watches.isEmpty {
            manager.stopUpdatingLocation()
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }
    }

    private func deliver(_ location: CLLocation) {
        let c = location.coordinate
        let coords = """
        {latitude:\(c.latitude),longitude:\(c.longitude),accuracy:\(location.horizontalAccuracy),\
        altitude:\(location.verticalAccuracy >= 0 ? "\(location.altitude)" : "null"),\
        altitudeAccuracy:\(location.verticalAccuracy >= 0 ? "\(location.verticalAccuracy)" : "null"),\
        heading:\(location.course >= 0 ? "\(location.course)" : "null"),\
        speed:\(location.speed >= 0 ? "\(location.speed)" : "null")}
        """
        let timestamp = Int(location.timestamp.timeIntervalSince1970 * 1000)
        for id in pending { call("success(\(id), \(coords), \(timestamp), false)") }
        for id in watches { call("success(\(id), \(coords), \(timestamp), true)") }
        pending.removeAll()
        stopIfIdle()
        setCookies(latitude: c.latitude, longitude: c.longitude)
    }

    private func fail(_ id: Int, code: Int, message: String, keep: Bool) {
        call("failure(\(id), \(code), \(Self.jsString(message)), \(keep))")
    }

    private func failAll(code: Int, message: String) {
        for id in pending { fail(id, code: code, message: message, keep: false) }
        for id in watches { fail(id, code: code, message: message, keep: true) }
        pending.removeAll()
        stopIfIdle()
    }

    private func scheduleTimeout(for id: Int, after seconds: Double) {
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(seconds))
            guard let self, self.pending.remove(id) != nil else { return }
            self.fail(id, code: 3, message: "Timeout expired", keep: false)
            self.stopIfIdle()
        }
    }

    private func call(_ function: String) {
        webView?.evaluateJavaScript("window.__sngineLocation && window.__sngineLocation.\(function)")
    }

    private func setCookies(latitude: Double, longitude: Double) {
        guard let host = URLRouter.host(of: SngineConfig.SITE_URL), let store = webView?.configuration.websiteDataStore.httpCookieStore else {
            return
        }
        for (name, value) in [("lat", latitude), ("long", longitude)] {
            if let cookie = HTTPCookie(properties: [.domain: host, .path: "/", .name: name, .value: "\(value)"]) {
                store.setCookie(cookie)
            }
        }
    }

    /// Location is off or denied: offer the Settings app once per session.
    private func showSettingsHint() {
        guard !shownSettingsHint else { return }
        shownSettingsHint = true
        let alert = UIAlertController(
            title: String(localized: "Location is off"),
            message: String(localized: "Turn on Location Services for this app in Settings to use location features."),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: String(localized: "Not now"), style: .cancel))
        alert.addAction(UIAlertAction(title: String(localized: "Settings"), style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        host?.present(alert)
    }

    private static func jsString(_ value: String) -> String {
        let data = try? JSONSerialization.data(withJSONObject: [value])
        return data.flatMap { String(data: $0, encoding: .utf8) }.map { String($0.dropFirst().dropLast()) } ?? "\"\""
    }
}

extension LocationBridge: CLLocationManagerDelegate {

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        MainActor.assumeIsolated {
            guard !pending.isEmpty || !watches.isEmpty else { return }
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.manager.startUpdatingLocation()
            case .denied, .restricted:
                failAll(code: 1, message: "User denied Geolocation")
                showSettingsHint()
            default:
                break
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        MainActor.assumeIsolated {
            deliver(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let code = (error as? CLError)?.code
        MainActor.assumeIsolated {
            switch code {
            case .locationUnknown:
                break // Still trying; Core Location keeps updating.
            case .denied:
                failAll(code: 1, message: "Location services are off")
                showSettingsHint()
            default:
                failAll(code: 2, message: "Position unavailable")
            }
        }
    }
}
