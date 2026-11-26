import SwiftUI

/// Native "you're offline / something went wrong" screen with a retry button.
struct OfflineView: View {
    let failure: WebState.Failure
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: failure == .offline ? "wifi.slash" : "exclamationmark.triangle")
                .font(.system(size: 52, weight: .light))
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
            Text(failure == .offline ? "You're offline" : "Something went wrong")
                .font(.title2.weight(.semibold))
            Text(failure == .offline
                 ? "Check your internet connection and try again."
                 : "The page couldn't be loaded. Please try again.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Try again", action: retry)
                .buttonStyle(.borderedProminent)
                .tint(Color("BrandPrimary"))
                .controlSize(.large)
                .padding(.top, 12)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}
