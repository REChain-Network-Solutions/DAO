/**
 * UrlRouterTest
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.web

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class UrlRouterTest {

    private val router = UrlRouter("https://demo.sngine.com/", "sngine", openExternalLinksInBrowser = false)
    private val externalRouter = UrlRouter("https://demo.sngine.com/", "sngine", openExternalLinksInBrowser = true)

    @Test
    fun `site links load in the webview`() {
        assertEquals(UrlAction.Default, router.route("https://demo.sngine.com/posts/1"))
        assertEquals(UrlAction.Default, externalRouter.route("https://www.demo.sngine.com/reels"))
        assertEquals(UrlAction.Default, externalRouter.route("https://cdn.demo.sngine.com/a.jpg"))
    }

    @Test
    fun `external links follow the config`() {
        assertEquals(UrlAction.Default, router.route("https://youtube.com/watch?v=1"))
        assertEquals(
            UrlAction.OpenExternally("https://youtube.com/watch?v=1"),
            externalRouter.route("https://youtube.com/watch?v=1"),
        )
        // A look-alike host is not the site.
        assertEquals(
            UrlAction.OpenExternally("https://evildemo.sngine.com.attacker.io/"),
            externalRouter.route("https://evildemo.sngine.com.attacker.io/"),
        )
    }

    @Test
    fun `app schemes open other apps`() {
        assertEquals(UrlAction.OpenExternally("tel:+123456"), router.route("tel:+123456"))
        assertEquals(UrlAction.OpenExternally("mailto:a@b.com"), router.route("mailto:a@b.com"))
        assertEquals(UrlAction.OpenExternally("whatsapp://send?text=hi"), router.route("whatsapp://send?text=hi"))
        assertEquals(UrlAction.OpenIntent("intent://scan/#Intent;end"), router.route("intent://scan/#Intent;end"))
    }

    @Test
    fun `sngine special links`() {
        assertEquals(UrlAction.Reload(home = false), router.route("refresh:android"))
        assertEquals(UrlAction.Reload(home = true), router.route("refresh:URL"))
        assertEquals(UrlAction.Share("https://demo.sngine.com/x"), router.route("share:https://demo.sngine.com/x"))
        assertEquals(UrlAction.RateApp, router.route("rate:android"))
        assertEquals(UrlAction.Exit, router.route("exit:android"))
    }

    @Test
    fun `deep links only open this website`() {
        assertEquals(UrlAction.Load("https://demo.sngine.com/posts/1"), router.route("sngine://demo.sngine.com/posts/1"))
        assertEquals("https://demo.sngine.com/", router.deepLinkToHttps("sngine://demo.sngine.com/"))
        assertNull(router.deepLinkToHttps("sngine://attacker.io/phish"))
        assertNull(router.deepLinkToHttps("https://demo.sngine.com/"))
    }

    @Test
    fun `web-internal schemes are left to the webview`() {
        assertEquals(UrlAction.Default, router.route("about:blank"))
        assertEquals(UrlAction.Default, router.route("data:text/html,hi"))
        assertEquals(UrlAction.Default, router.route("blob:https://demo.sngine.com/uuid"))
    }

    @Test
    fun `isInternal handles bad input`() {
        assertTrue(router.isInternal("https://demo.sngine.com"))
        assertFalse(router.isInternal("not a url"))
        assertFalse(router.isInternal(""))
    }
}
