/**
 * OfflineView
 *
 * @package Sngine
 * @author Zamblek
 */

package sngine.app.webview.ui

import androidx.core.view.isVisible
import sngine.app.webview.R
import sngine.app.webview.databinding.ViewOfflineBinding

/** Native "you're offline / something went wrong" screen with a retry button. */
class OfflineView(private val binding: ViewOfflineBinding, onRetry: () -> Unit) {

    init {
        binding.offlineRetry.setOnClickListener { onRetry() }
    }

    val isShowing: Boolean get() = binding.root.isVisible

    fun show(online: Boolean) {
        binding.offlineTitle.setText(if (online) R.string.error_title else R.string.offline_title)
        binding.offlineMessage.setText(if (online) R.string.error_message else R.string.offline_message)
        binding.root.isVisible = true
    }

    fun hide() {
        binding.root.isVisible = false
    }
}
