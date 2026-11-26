import SwiftUI

/// The native screens drawn on top of the website: the splash and the offline/error screen.
struct Overlays: View {
    let state: WebState
    let retry: () -> Void

    var body: some View {
        ZStack {
            if let failure = state.failure {
                OfflineView(failure: failure, retry: retry)
                    .transition(.opacity)
            }
            if state.showSplash {
                SplashOverlay()
                    .transition(.opacity.combined(with: .scale(scale: 1.08)))
            }
        }
        .ignoresSafeArea()
    }
}
