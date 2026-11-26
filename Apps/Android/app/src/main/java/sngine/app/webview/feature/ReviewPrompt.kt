/**
 * ReviewPrompt
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.feature

import android.app.Activity
import android.content.Context
import androidx.core.content.edit
import com.google.android.play.core.review.ReviewManagerFactory
import com.google.android.play.core.ktx.launchReview
import com.google.android.play.core.ktx.requestReview
import kotlinx.coroutines.CancellationException
import sngine.app.webview.SngineConfig
import java.util.concurrent.TimeUnit

/** When to ask for a rating. Pure Kotlin so it can be unit tested. */
class ReviewPolicy(private val minDays: Int, private val minLaunches: Int, private val remindDays: Int) {

    fun shouldAsk(installedAt: Long, launches: Int, lastAskedAt: Long, now: Long): Boolean {
        val daysSinceInstall = TimeUnit.MILLISECONDS.toDays(now - installedAt)
        val daysSinceAsked = TimeUnit.MILLISECONDS.toDays(now - lastAskedAt)
        return daysSinceInstall >= minDays &&
            launches >= minLaunches &&
            (lastAskedAt == 0L || daysSinceAsked >= remindDays)
    }
}

/**
 * Google Play in-app review, gated by the rating settings in [SngineConfig].
 * Google decides whether the dialog is actually shown, so this never blocks the user.
 */
class ReviewPrompt(context: Context) {

    private val prefs = context.getSharedPreferences("review_prompt", Context.MODE_PRIVATE)
    private val policy = ReviewPolicy(
        SngineConfig.RATING_MIN_DAYS,
        SngineConfig.RATING_MIN_LAUNCHES,
        SngineConfig.RATING_REMIND_DAYS,
    )

    /** Call once per app launch. */
    fun recordLaunch() {
        prefs.edit {
            if (!prefs.contains(KEY_INSTALLED_AT)) putLong(KEY_INSTALLED_AT, System.currentTimeMillis())
            putInt(KEY_LAUNCHES, prefs.getInt(KEY_LAUNCHES, 0) + 1)
        }
    }

    suspend fun maybeAsk(activity: Activity) {
        if (!SngineConfig.ENABLE_RATING_PROMPT) return
        val now = System.currentTimeMillis()
        val due = policy.shouldAsk(
            installedAt = prefs.getLong(KEY_INSTALLED_AT, now),
            launches = prefs.getInt(KEY_LAUNCHES, 0),
            lastAskedAt = prefs.getLong(KEY_LAST_ASKED_AT, 0),
            now = now,
        )
        if (!due) return
        prefs.edit { putLong(KEY_LAST_ASKED_AT, now) }
        try {
            val manager = ReviewManagerFactory.create(activity)
            manager.launchReview(activity, manager.requestReview())
        } catch (e: CancellationException) {
            throw e
        } catch (_: Exception) {
            // Play Store missing or quota reached: nothing to do.
        }
    }

    private companion object {
        const val KEY_INSTALLED_AT = "installed_at"
        const val KEY_LAUNCHES = "launches"
        const val KEY_LAST_ASKED_AT = "last_asked_at"
    }
}
