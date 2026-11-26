import StoreKit
import UIKit

/// When to ask for a rating. Pure Swift so it can be unit tested.
struct ReviewPolicy {
    let minDays: Int
    let minLaunches: Int
    let remindDays: Int

    func shouldAsk(installedAt: Date, launches: Int, lastAskedAt: Date?, now: Date) -> Bool {
        let daysSinceInstall = Self.days(from: installedAt, to: now)
        let remindOK = lastAskedAt.map { Self.days(from: $0, to: now) >= remindDays } ?? true
        return daysSinceInstall >= minDays && launches >= minLaunches && remindOK
    }

    private static func days(from start: Date, to end: Date) -> Int {
        Int(end.timeIntervalSince(start) / 86_400)
    }
}

/// App Store rating dialog, gated by the rating settings in SngineConfig.
/// Apple decides whether the dialog is actually shown, so this never blocks the user.
@MainActor
final class ReviewPrompt {
    private let defaults = UserDefaults.standard
    private let policy = ReviewPolicy(
        minDays: SngineConfig.RATING_MIN_DAYS,
        minLaunches: SngineConfig.RATING_MIN_LAUNCHES,
        remindDays: SngineConfig.RATING_REMIND_DAYS
    )

    private enum Key {
        static let installedAt = "review.installedAt"
        static let launches = "review.launches"
        static let lastAskedAt = "review.lastAskedAt"
    }

    /// Call once per app launch.
    func recordLaunch() {
        if defaults.object(forKey: Key.installedAt) == nil {
            defaults.set(Date(), forKey: Key.installedAt)
        }
        defaults.set(defaults.integer(forKey: Key.launches) + 1, forKey: Key.launches)
    }

    func maybeAsk(in scene: UIWindowScene?) {
        guard SngineConfig.ENABLE_RATING_PROMPT, let scene else { return }
        let now = Date()
        let due = policy.shouldAsk(
            installedAt: defaults.object(forKey: Key.installedAt) as? Date ?? now,
            launches: defaults.integer(forKey: Key.launches),
            lastAskedAt: defaults.object(forKey: Key.lastAskedAt) as? Date,
            now: now
        )
        guard due else { return }
        defaults.set(now, forKey: Key.lastAskedAt)
        AppStore.requestReview(in: scene)
    }
}
