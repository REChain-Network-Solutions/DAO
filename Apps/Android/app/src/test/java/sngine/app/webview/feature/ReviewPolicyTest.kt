/**
 * ReviewPolicyTest
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.util.concurrent.TimeUnit

class ReviewPolicyTest {

    private val policy = ReviewPolicy(minDays = 3, minLaunches = 10, remindDays = 2)
    private val day = TimeUnit.DAYS.toMillis(1)
    private val now = 100 * day

    @Test
    fun `waits for days and launches`() {
        assertFalse(policy.shouldAsk(installedAt = now - 2 * day, launches = 50, lastAskedAt = 0, now = now))
        assertFalse(policy.shouldAsk(installedAt = now - 5 * day, launches = 9, lastAskedAt = 0, now = now))
        assertTrue(policy.shouldAsk(installedAt = now - 3 * day, launches = 10, lastAskedAt = 0, now = now))
    }

    @Test
    fun `waits between asks`() {
        val installed = now - 30 * day
        assertFalse(policy.shouldAsk(installed, launches = 20, lastAskedAt = now - day, now = now))
        assertTrue(policy.shouldAsk(installed, launches = 20, lastAskedAt = now - 2 * day, now = now))
    }
}
