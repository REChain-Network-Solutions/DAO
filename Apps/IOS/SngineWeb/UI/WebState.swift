import Observation

/// State shown by the SwiftUI overlays on top of the web view.
@MainActor
@Observable
final class WebState {
    enum Failure {
        case offline
        case error
    }

    var showSplash = true
    var failure: Failure?

    /// True while an overlay covers the website (it then receives the touches).
    var isCovering: Bool { showSplash || failure != nil }
}
