import Foundation
import Testing
@testable import SngineWeb

struct ReviewPolicyTests {
    private let policy = ReviewPolicy(minDays: 3, minLaunches: 10, remindDays: 2)
    private let day: TimeInterval = 86_400
    private let now = Date(timeIntervalSince1970: 100 * 86_400)

    @Test func waitsForDaysAndLaunches() {
        #expect(!policy.shouldAsk(installedAt: now - 2 * day, launches: 50, lastAskedAt: nil, now: now))
        #expect(!policy.shouldAsk(installedAt: now - 5 * day, launches: 9, lastAskedAt: nil, now: now))
        #expect(policy.shouldAsk(installedAt: now - 3 * day, launches: 10, lastAskedAt: nil, now: now))
    }

    @Test func waitsBetweenAsks() {
        let installed = now - 30 * day
        #expect(!policy.shouldAsk(installedAt: installed, launches: 20, lastAskedAt: now - day, now: now))
        #expect(policy.shouldAsk(installedAt: installed, launches: 20, lastAskedAt: now - 2 * day, now: now))
    }
}
