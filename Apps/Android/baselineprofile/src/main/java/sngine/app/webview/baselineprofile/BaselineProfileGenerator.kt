/**
 * BaselineProfileGenerator
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.baselineprofile

import androidx.benchmark.macro.junit4.BaselineProfileRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.uiautomator.By
import androidx.test.uiautomator.Until
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

/** Records the cold-start path (splash → first page) so it ships pre-compiled. */
@RunWith(AndroidJUnit4::class)
class BaselineProfileGenerator {

    @get:Rule
    val rule = BaselineProfileRule()

    @Test
    fun generate() = rule.collect(packageName = "sngine.app.webview") {
        pressHome()
        startActivityAndWait()
        device.wait(Until.hasObject(By.clazz("android.webkit.WebView")), 15_000)
    }
}
