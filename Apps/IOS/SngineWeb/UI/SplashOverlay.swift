import SwiftUI

/// Same picture as the launch screen (Info.plist → UILaunchScreen), so the hand-over is seamless.
/// It stays until the website has painted, then fades out.
/// To rebrand, change SplashLogo and SplashBackground in Assets.xcassets.
struct SplashOverlay: View {
    var body: some View {
        ZStack {
            Color("SplashBackground")
            Image("SplashLogo")
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
